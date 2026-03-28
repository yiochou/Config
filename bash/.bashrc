source ~/.bash_prompt

# === Alias =================================

alias p="cd ~/Projects"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ll="ls -alh"
alias grep="grep --color=auto"
alias path='echo -e ${PATH//:/\\n}'

# Reload
alias reload="exec ${SHELL} -l"

# Date
alias week="date +%V"
alias timestamp="date +%s"

# IP 
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

