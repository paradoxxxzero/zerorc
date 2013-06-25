source ~/.zerorc/antigen/antigen.zsh

# Conf on oh-my-zsh
export COMPLETION_WAITING_DOTS=true
export DISABLE_CORRECTION=true
# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle virtualenv
antigen bundle virtualenvwrapper
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme paradoxxxzero/oh-my-zsh-theme one

# Tell antigen that you're done.
antigen apply

source ~/.zerorc/init.zsh
