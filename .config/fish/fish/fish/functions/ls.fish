# Defined in - @ line 1
function ls --wraps='exa -lah' --description 'alias ls=exa -lah'
  exa -lah $argv;
end
