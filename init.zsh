### Envs

# Common
export PATH=/usr/share/perl5/site_perl/auto/share/dist/Cope:$PATH:/usr/bin/vendor_perl:/usr/bin/site_perl:$HOME/.gem/ruby/2.0.0/bin:$HOME/.zerorc/carton/bin
export EDITOR="emacsclient -c"
export BROWSER=chromium
export WORDCHARS="_-"

# Python
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export WORKON_HOME=~/.envs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
export GIT_MERGE_AUTOEDIT=no

export HISTORY=1000000
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTFILE=$HOME/.history


### Aliases

alias azerty='sudo loadkeys fr-bepo'
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
alias resource='source ~/.zshrc'
alias sudo='sudo '

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'
alias -g ........='../../../../../../..'
alias -g .........='../../../../../../../..'


### Options

# History
setopt append_history
setopt share_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_expire_dups_first
setopt hist_find_no_dups


### Bindings
bindkey "^[r" history-incremental-search-forward

### Completion
zstyle ':completion:*::::' completer _expand _complete _approximate _ignored

### Functions

# Emacs
y () {
    args=$*
    parts=(${(s/:/)args})
    lno=""
    col=""
    [[ -n $parts[2] ]] && lno="+$parts[2]"
    [[ -n $parts[3] ]] && col=":$parts[3]"
    emacsclient -n $lno$col $parts[1]
}

# Fuzzy find
f() {
    find . -name "*"$1"*" ${(@)argv[2,$#]}
}

# Strict find
sf() {
    find . -name $*
}


### Hightlights

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[default]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=red'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[assign]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'
ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS+=('sudo')
ZSH_HIGHLIGHT_KEYWORD_KEYWORDS+=('rm -rf *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_KEYWORD_KEYWORDS+=('rm -fr *' 'fg=white,bold,bg=red')
