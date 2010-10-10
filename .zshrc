## zsh rc file made by paradoxx.zero
## Thanks to all the people which made their zshrc public

## Loading zsh configurations from .zsh directory


#if [ -z "$STY" ]; then
#   if [ "`id -u`" -eq 0 ]; then
#       echo "Not starting byobu since we are root"
#       for file in $HOME/.zsh/*; 
#       do
#	   echo "Loading "$file
#	source $file
#       done
#   else      
#      echo "Starting byobu"
#      #exec byobu -xRR -U -A
#      exec byobu
#   fi
#else 
#    echo "byobu is already started... loading .zsh/* rc files"
    for file in $HOME/.zsh/*; 
    do
#	echo "Loading "$file
	source $file
    done
#fi




