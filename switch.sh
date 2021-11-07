 #!/usr/bin/env bash

 t=$(optimus-manager --print-mode | cut -d ':' -f 2)

 if [ $t == 'hybrid' ]
 then
     optimus-manager --switch nvidia --no-confirm
 elif [ $t == 'nvidia' ]
 then
     optimus-manager --switch hybrid --no-confirm
 else
     echo "Script doesn't work!!"
 fi
