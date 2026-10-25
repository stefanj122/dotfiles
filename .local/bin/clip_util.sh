#!/usr/bin/env bash
set -euo pipefail

MAGENTO_DIR="${MAGENTO_DIR:-$HOME/magento}"
CMDS_FILE="${CMDS_FILE:-$MAGENTO_DIR/.rofi_commands.sh}"
CMDS_DIR="${CMDS_DIR:-$MAGENTO_DIR/.rofi_commands.d}"
LEGACY_CMDS_FILE="${LEGACY_CMDS_FILE:-$MAGENTO_DIR/.rofi_commands.tsv}"
ROFI_BIN="${ROFI_BIN:-rofi}"
ROFI_DIR="${ROFI_DIR:-$HOME/.config/rofi/launchers/type-1}"
ROFI_STYLE="${ROFI_STYLE:-style-8}"
ROFI_THEME="${ROFI_THEME:-$ROFI_DIR/$ROFI_STYLE.rasi}"

ROFI_THEME_ARGS=()
if [[ -f "$ROFI_THEME" ]]; then
  ROFI_THEME_ARGS=(-theme "$ROFI_THEME")
fi

CMD_GROUPS=()
CMD_LABELS=()
CMD_BODIES=()
CMD_SOURCES_LOADED=()

add_cmd() {
  local group="$1"
  local label="$2"
  local body

  body="$(cat)"
  body="${body%$'\n'}"

  CMD_GROUPS+=("$group")
  CMD_LABELS+=("$label")
  CMD_BODIES+=("$body")
}

escape_dq() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  printf '%s' "$s"
}

migrate_legacy_tsv() {
  local out="$CMDS_FILE"

  mkdir -p "$(dirname "$out")"
  {
    echo '#!/usr/bin/env bash'
    echo '# Auto-migrated from .rofi_commands.tsv'
    echo '# Format: add_cmd "Group" "Label" <<'"'"'CMD'"'"''
    echo '#         <command, one or more lines>'
    echo '#         CMD'
    echo

    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      [[ "$line" =~ ^[[:space:]]*# ]] && continue
      [[ "$line" != *"|"* ]] && continue

      local group rest label cmd
      group="${line%%|*}"
      rest="${line#*|}"
      label="${rest%%|*}"
      cmd="${rest#*|}"

      group="${group#${group%%[![:space:]]*}}"
      group="${group%${group##*[![:space:]]}}"
      label="${label#${label%%[![:space:]]*}}"
      label="${label%${label##*[![:space:]]}}"
      cmd="${cmd#${cmd%%[![:space:]]*}}"
      cmd="${cmd%${cmd##*[![:space:]]}}"

      [[ -z "$group" || -z "$label" || -z "$cmd" ]] && continue

      printf 'add_cmd "%s" "%s" <<'"'"'CMD'"'"'\n' "$(escape_dq "$group")" "$(escape_dq "$label")"
      printf '%s\n' "$cmd"
      echo 'CMD'
      echo
    done < "$LEGACY_CMDS_FILE"
  } > "$out"
}

write_default_commands() {
  mkdir -p "$CMDS_DIR"

  cat > "$CMDS_DIR/10-magento.sh" <<'TEMPLATE'
#!/usr/bin/env bash

add_cmd "Magento" "Cache flush" <<'CMD'
cd ~/magento && php bin/magento cache:flush
CMD

add_cmd "Magento" "Indexer reindex" <<'CMD'
cd ~/magento && php bin/magento indexer:reindex
CMD
TEMPLATE

  cat > "$CMDS_DIR/20-es.sh" <<'TEMPLATE'
#!/usr/bin/env bash

add_cmd "ES" "List indices" <<'CMD'
curl -s "http://127.0.0.1:9200/_cat/indices?v"
CMD
TEMPLATE

  cat > "$CMDS_DIR/30-redis.sh" <<'TEMPLATE'
#!/usr/bin/env bash

add_cmd "Redis" "Ping" <<'CMD'
redis-cli ping
CMD
TEMPLATE

  cat > "$CMDS_DIR/40-database.sh" <<'TEMPLATE'
#!/usr/bin/env bash

add_cmd "Dump baze" "Export DB" <<'CMD'
cd ~/magento && mysqldump -u root -p magento > /tmp/magento_dump.sql
CMD
TEMPLATE
}

has_commands_in_dir() {
  [[ -d "$CMDS_DIR" ]] || return 1

  shopt -s nullglob
  local files=("$CMDS_DIR"/*.sh)
  shopt -u nullglob

  [[ ${#files[@]} -gt 0 ]]
}

slugify() {
  local input="$1"
  local out
  out="$(printf '%s' "$input" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/-\+/-/g; s/^-//; s/-$//')"
  printf '%s' "$out"
}

split_single_file_into_dir() {
  [[ -f "$CMDS_FILE" ]] || {
    echo "Nema fajla za split: $CMDS_FILE" >&2
    return 1
  }

  CMD_GROUPS=()
  CMD_LABELS=()
  CMD_BODIES=()
  # shellcheck disable=SC1090
  source "$CMDS_FILE"

  [[ ${#CMD_GROUPS[@]} -gt 0 ]] || {
    echo "Nema komandi u $CMDS_FILE" >&2
    return 1
  }

  mkdir -p "$CMDS_DIR"
  local backup="$CMDS_FILE.bak.$(date +%Y%m%d_%H%M%S)"

  local -A seen=()
  local -a groups=()
  local idx group file slug order label body

  for idx in "${!CMD_GROUPS[@]}"; do
    group="${CMD_GROUPS[$idx]}"
    [[ -n "$group" ]] || continue
    if [[ -z "${seen[$group]+x}" ]]; then
      seen[$group]=1
      groups+=("$group")
    fi
  done

  for idx in "${!groups[@]}"; do
    group="${groups[$idx]}"
    order=$(printf '%02d' $(( (idx + 1) * 10 )))
    slug="$(slugify "$group")"
    [[ -n "$slug" ]] || slug="group-$((idx + 1))"
    file="$CMDS_DIR/${order}-${slug}.sh"

    {
      echo '#!/usr/bin/env bash'
      echo
      for label in "${!CMD_GROUPS[@]}"; do
        [[ "${CMD_GROUPS[$label]}" == "$group" ]] || continue
        body="${CMD_BODIES[$label]}"
        [[ -n "$body" ]] || continue
        printf 'add_cmd "%s" "%s" <<'"'"'CMD'"'"'\n' "$(escape_dq "$group")" "$(escape_dq "${CMD_LABELS[$label]}")"
        printf '%s\n' "$body"
        echo 'CMD'
        echo
      done
    } > "$file"
  done

  mv "$CMDS_FILE" "$backup"
  cat > "$CMDS_FILE" <<'TEMPLATE'
#!/usr/bin/env bash
# Legacy commands file moved to backup.
# Use ~/.rofi_commands.d/*.sh for command definitions.
TEMPLATE

  echo "Split zavrsen."
  echo "Backup: $backup"
  echo "Novi fajlovi: $CMDS_DIR/*.sh"
}

print_help() {
  cat <<EOF
Usage: $(basename "$0") [option]

Options:
  --list-sources    Ispisi izvore iz kojih su komande ucitane
  --migrate-only    Ucitaj komande i ispisi broj ucitanih stavki
  --split-commands  Podeli $CMDS_FILE u vise fajlova unutar $CMDS_DIR
  --help            Prikazi ovu poruku
EOF
}

ensure_commands_file() {
  if [[ -f "$CMDS_FILE" ]]; then
    return
  fi

  if has_commands_in_dir; then
    return
  fi

  if [[ -f "$LEGACY_CMDS_FILE" ]]; then
    migrate_legacy_tsv
    return
  fi

  write_default_commands
}

load_commands() {
  CMD_GROUPS=()
  CMD_LABELS=()
  CMD_BODIES=()
  CMD_SOURCES_LOADED=()

  if [[ -f "$CMDS_FILE" ]]; then
    # shellcheck disable=SC1090
    source "$CMDS_FILE"
    CMD_SOURCES_LOADED+=("$CMDS_FILE")
  fi

  if [[ -d "$CMDS_DIR" ]]; then
    local file
    shopt -s nullglob
    local files=("$CMDS_DIR"/*.sh)
    shopt -u nullglob

    for file in "${files[@]}"; do
      # shellcheck disable=SC1090
      source "$file"
      CMD_SOURCES_LOADED+=("$file")
    done
  fi

  if [[ ${#CMD_GROUPS[@]} -eq 0 ]]; then
    echo "Nema komandi u $CMDS_FILE ili $CMDS_DIR/*.sh" >&2
    exit 1
  fi
}

rofi_pick() {
  local prompt="$1"
  local out

  set +e
  out="$($ROFI_BIN -dmenu -i -p "$prompt" "${ROFI_THEME_ARGS[@]}")"
  ROFI_EXIT=$?
  set -e

  printf '%s' "$out"
}

copy_to_clipboard() {
  local text="$1"

  if command -v wl-copy >/dev/null 2>&1; then
    printf '%s' "$text" | wl-copy
    return 0
  fi

  if command -v xclip >/dev/null 2>&1; then
    printf '%s' "$text" | xclip -selection clipboard
    return 0
  fi

  if command -v xsel >/dev/null 2>&1; then
    printf '%s' "$text" | xsel --clipboard --input
    return 0
  fi

  return 1
}

launch_editor() {
  local file="$1"
  local editor="${EDITOR:-vim}"

  if [[ -n "${TERMINAL:-}" ]] && command -v "$TERMINAL" >/dev/null 2>&1; then
    "$TERMINAL" -e "$editor" "$file"
    return
  fi

  if command -v kitty >/dev/null 2>&1; then
    kitty -e "$editor" "$file"
    return
  fi

  if command -v alacritty >/dev/null 2>&1; then
    alacritty -e "$editor" "$file"
    return
  fi

  if command -v wezterm >/dev/null 2>&1; then
    wezterm start -- "$editor" "$file"
    return
  fi

  if command -v gnome-terminal >/dev/null 2>&1; then
    gnome-terminal --wait -- "$editor" "$file"
    return
  fi

  if command -v xfce4-terminal >/dev/null 2>&1; then
    xfce4-terminal --command "$editor $file"
    return
  fi

  if command -v konsole >/dev/null 2>&1; then
    konsole --separate -e "$editor" "$file"
    return
  fi

  if command -v xterm >/dev/null 2>&1; then
    xterm -e "$editor" "$file"
    return
  fi

  if [[ -t 0 && -t 1 ]]; then
    "$editor" "$file"
    return
  fi

  return 1
}

edit_command() {
  local current="$1"
  local tmp edited

  tmp="$(mktemp /tmp/rofi_cmd.XXXXXX)"
  printf '%s\n' "$current" > "$tmp"

  if ! launch_editor "$tmp"; then
    rm -f "$tmp"
    return 1
  fi

  edited="$(cat "$tmp")"
  edited="${edited%$'\n'}"
  rm -f "$tmp"

  printf '%s' "$edited"
}

make_preview() {
  local cmd="$1"
  local one_line

  one_line="$(printf '%s' "$cmd" | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//')"
  if [[ ${#one_line} -gt 110 ]]; then
    printf '%s...' "${one_line:0:110}"
  else
    printf '%s' "$one_line"
  fi
}

get_groups() {
  local -A seen=()
  local i group

  for i in "${!CMD_GROUPS[@]}"; do
    group="${CMD_GROUPS[$i]}"
    [[ -n "$group" ]] || continue
    if [[ -z "${seen[$group]+x}" ]]; then
      seen[$group]=1
      printf '%s\n' "$group"
    fi
  done
}

pick_command_from_group() {
  local group="$1"
  local message selected exit_code idx body label
  local -a display_lines index_map

  for idx in "${!CMD_GROUPS[@]}"; do
    [[ "${CMD_GROUPS[$idx]}" == "$group" ]] || continue
    label="${CMD_LABELS[$idx]}"
    body="${CMD_BODIES[$idx]}"
    [[ -n "$label" && -n "$body" ]] || continue
    index_map+=("$idx")
    display_lines+=("$label  •  $(make_preview "$body")")
  done

  [[ ${#display_lines[@]} -gt 0 ]] || return 1

  message="Enter: copy    Alt+e: edit+copy    Alt+r: manual input    Alt+Shift+b: back"

  set +e
  selected="$(
    printf '%s\n' "${display_lines[@]}" | "$ROFI_BIN" -dmenu -i -format i \
      -p "Komanda: $group" \
      -mesg "$message" \
      "${ROFI_THEME_ARGS[@]}" \
      -kb-custom-1 "Alt+e" \
      -kb-custom-2 "Alt+r" \
      -kb-custom-3 "Alt+Shift+b"
  )"
  exit_code=$?
  set -e

  if [[ "$exit_code" -eq 1 && -z "$selected" ]]; then
    return 2
  fi

  PICK_EXIT="$exit_code"
  PICK_LABEL=""
  PICK_CMD=""

  if [[ "$exit_code" -eq 11 ]]; then
    return 0
  fi

  [[ "$selected" =~ ^[0-9]+$ ]] || return 3
  (( selected >= 0 )) || return 3
  (( selected < ${#index_map[@]} )) || return 3

  idx="${index_map[$selected]}"
  PICK_LABEL="${CMD_LABELS[$idx]}"
  PICK_CMD="${CMD_BODIES[$idx]}"
  return 0
}

copy_or_fail() {
  local cmd="$1"
  if copy_to_clipboard "$cmd"; then
    command -v notify-send >/dev/null 2>&1 && notify-send 'Komanda kopirana' "$(make_preview "$cmd")"
  else
    command -v notify-send >/dev/null 2>&1 && notify-send 'Greška' 'Nisam našao wl-copy/xclip/xsel'
    return 1
  fi
}

main() {
  case "${1:-}" in
    --migrate-only)
      ensure_commands_file
      load_commands
      echo "Loaded entries: ${#CMD_GROUPS[@]}"
      printf 'Loaded sources:\n'
      printf '  - %s\n' "${CMD_SOURCES_LOADED[@]}"
      exit 0
      ;;
    --split-commands)
      split_single_file_into_dir
      exit 0
      ;;
    --help|-h)
      print_help
      exit 0
      ;;
    --list-sources)
      ensure_commands_file
      load_commands
      printf '%s\n' "${CMD_SOURCES_LOADED[@]}"
      exit 0
      ;;
  esac

  ensure_commands_file
  load_commands

  while true; do
    local group
    group="$(get_groups | rofi_pick 'Kategorija')"
    [[ -z "$group" ]] && exit 0

    while true; do
      pick_command_from_group "$group" || {
        rc=$?
        if [[ "$rc" -eq 2 ]]; then
          exit 0
        fi
        break
      }

      local cmd=""
      case "${PICK_EXIT:-0}" in
        10)
          cmd="$PICK_CMD"
          [[ -z "$cmd" ]] && break
          cmd="$(edit_command "$cmd")"
          [[ -z "$cmd" ]] && break
          copy_or_fail "$cmd" || exit 1
          exit 0
          ;;
        11)
          cmd="$(rofi_pick 'Unesi komandu')"
          [[ -z "$cmd" ]] && continue
          copy_or_fail "$cmd" || exit 1
          exit 0
          ;;
        12)
          break
          ;;
        0)
          cmd="$PICK_CMD"
          [[ -z "$cmd" ]] && break
          copy_or_fail "$cmd" || exit 1
          exit 0
          ;;
        *)
          exit 0
          ;;
      esac
    done
  done
}

main "$@"
