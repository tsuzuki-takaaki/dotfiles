# aliases
alias la="ls -a"
alias ll="ls -l"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# rbenv
eval "$(rbenv init - zsh)"

# shell suggestion
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=158'
# shell highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
PROMPT="%B%F{46}%n@%m%f%b %1~ %# "

# Terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# LLVM
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

## Rust
. "$HOME/.cargo/env"

## Maybe plugin compatibility
export PATH="/opt/homebrew/opt/mysql-client@8.4/bin:$PATH"

## Go
export PATH=$PATH:$(go env GOPATH)/bin

[ -f "/Users/tsuzuki-takaaki/.ghcup/env" ] && . "/Users/tsuzuki-takaaki/.ghcup/env" # ghcup-env
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tsuzuki-takaaki/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tsuzuki-takaaki/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tsuzuki-takaaki/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tsuzuki-takaaki/google-cloud-sdk/completion.zsh.inc'; fi
