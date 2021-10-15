function tors --wraps='transmission-cli -f sus.sh' --description 'alias tors=transmission-cli -f sus.sh'
  transmission-cli -f sus.sh $argv; 
end
