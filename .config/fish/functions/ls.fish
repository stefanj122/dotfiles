# Defined in - @ line 1
function ls --wraps='eza -lah' --description 'alias ls=eza -lah'
  exa -lah $argv;
end
