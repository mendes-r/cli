# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source ~/iTerm/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Ignores a command if the same command was recorded before
export HISTCONTROL=ignoredups

# Add ~/bin to PATH
export PATH=/Users/ricardomendes/Library/Python/3.9/bin:$PATH
export PATH=$PATH:~/bin

# Some helpful aliases
alias latexpack="cd /Library/TeX/Distributions/.DefaultTeX/Contents/AllTexmf/texmf/tex/latex"
alias t="tree --du -h -L"
alias k="kubectl"
alias la="ls -alh"
alias ll="ls -l"
alias l.="ls -d .*"
alias dev="cd ~/Developer/Projects/"
alias apps="cd; cd ../../Applications/"
alias ric="cd; cd ./Documents/RicardoSync/"
alias mestrado="cd; cd ./Documents/RicardoSync/1-temas/2-code/1-improvement/mestrado/"
alias vi="vim"
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias free='top -l 1 -s 0 | grep PhysMem'
alias ports='lsof -i -P -n | grep LISTEN'
alias ij="open -a /Applications/IntelliJ\ IDEA\ CE.app"
alias mestrado="cd ~/Documents/RicardoSync/1-temas/2-code/1-improvement/mestrado"
alias tempo="curl wttr.in/oporto"
# Swap key to enable '< >' key on mechanical keyboard
alias swpk="~/Developer/Projects/shell/key-swap.sh"

# Plugin
# Zsh syntaxe highlighting
source /Users/ricardomendes/iTerm/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/ricardomendes/.sdkman"
[[ -s "/Users/ricardomendes/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/ricardomendes/.sdkman/bin/sdkman-init.sh"
