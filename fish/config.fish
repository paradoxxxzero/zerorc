set VIRTUALFISH_HOME ~/.envs
set -x EDITOR emacsclient
set -x VISUAL emacsclient

set -x PATH /usr/share/perl5/site_perl/auto/share/dist/Cope $PATH /usr/bin/vendor_perl /usr/bin/site_perl ~/.gem/ruby/2.0.0/bin ~/.zerorc/carton/bin
. ~/.zerorc/fish/virtualfish/virtual.fish

alias azerty='sudo loadkeys fr-dvorak-bepo'
alias c='rsync -ahP'
alias cls='clear'
alias d='cdproject'
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gcp='git cherry-pick'
alias gd='git diff --word-diff'
alias gf='git fetch'
alias gh='git push'
alias gk='git checkout'
alias gl='git log'
alias gm='git merge'
alias gn='git clone'
alias go='git remote'
alias gp='git pull'
alias gr='git reset'
alias gsf='git submodule foreach --recursive'
alias gsfu='git submodule foreach --recursive git submodule update'
alias gsu='git submodule update'
alias gt='git status -sb'
alias m='rsync -ahP --remove-source-files'
