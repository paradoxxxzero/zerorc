source ~/.zerorc/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme robbyrussell

# Tell antigen that you're done.
antigen apply

source ~/.zerorc/init.zsh

if [ -f /usr/bin/virtualenvwrapper_lazy.sh ]; then
    source /usr/bin/virtualenvwrapper_lazy.sh
fi
