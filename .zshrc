#!/bin/zsh

## zsh rc file made by paradoxx.zero
## Thanks to all the people which made their zshrc public
## Loading zsh configurations from ~/.zsh.d directory
setopt extendedglob
for file in $HOME/.zsh.d/*~X_*; 
do
    source $file
done
