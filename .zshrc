source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export DENO_INSTALL="/Users/alexanderpierce/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=158'
PROMPT="%B%F{46}%n@%m%f%b %1~ %# "

eval "$(rbenv init - zsh)"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="${HOME}/.jsvu/bin:${PATH}"


# bun completions
[ -s "/Users/alexanderpierce/.bun/_bun" ] && source "/Users/alexanderpierce/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
# export PATH="$PATH:$HOME/development/flutter/bin"


# pnpm
export PNPM_HOME="/Users/alexanderpierce/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
