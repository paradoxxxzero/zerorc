set VIRTUALFISH_HOME ~/.envs
set -x BROWSER google-chrome-unstable
set -x EDITOR emacsclient
set -x VISUAL emacsclient
set -x BUILDDIR /src/aur
set -x PYTHONSTARTUP ~/.pythonrc.py

set -x ANDROID_HOME /opt/android-sdk
set -x ANDROID_SWT /usr/share/java

# Get X auth from current gnome session, useful for butterfly server
set -x GNOME_SESSION_ID (pgrep -u $USER gnome-session)
set -x DISPLAY (sed 's/\o000/\n/g;' < /proc/$GNOME_SESSION_ID/environ | grep DISPLAY | cut -d '=' -f 2-)
set -x XAUTHORITY  (sed 's/\o000/\n/g;' < /proc/$GNOME_SESSION_ID/environ | grep XAUTHORITY | cut -d '=' -f 2-)
set -x DBUS_SESSION_BUS_ADDRESS (sed 's/\o000/\n/g;' < /proc/$GNOME_SESSION_ID/environ | grep DBUS_SESSION_BUS_ADDRESS | cut -d '=' -f 2-)

set -x PATH (cope_path) $PATH /usr/bin/core_perl /usr/bin/vendor_perl /usr/bin/site_perl ~/.gem/ruby/2.2.0/bin ~/.zerorc/cask/bin $ANDROID_HOME/tools $ANDROID_HOME/platform-tools
. ~/.zerorc/fish/virtualfish/virtual.fish
. ~/.zerorc/fish/autojump.fish

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
alias ww='pip wheel --wheel-dir=/src/wheel'
alias w='pip install --use-wheel --no-index --find-links=/src/wheel'
alias W='sudo pip install --use-wheel --no-index --find-links=/src/wheel'
