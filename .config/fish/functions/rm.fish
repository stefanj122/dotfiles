# Defined in - @ line 1
function rm --wraps='=trash -i' --wraps='trash -i' --description 'alias rm=trash -i'
 command trash -i $argv;
end
