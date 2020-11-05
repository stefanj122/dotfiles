# Defined in - @ line 1
function ranger --wraps='ranger --choosedir=$HOME/.rangerdir; cd (cat ~/.rangerdir)' --description 'alias ranger=ranger --choosedir=$HOME/.rangerdir; cd (cat ~/.rangerdir)'
 command ranger --choosedir=$HOME/.rangerdir; cd (cat ~/.rangerdir) $argv;
end
