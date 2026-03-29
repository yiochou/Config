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

# === editor ===
export EDITOR="zed --wait"

# === zoxide (smart cd) ===
eval "$(zoxide init bash)"

# === yazi wrapper (cd to last dir on exit) ===
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# === Terminal tab title (git repo name or directory) ===
__update_tab_title() {
	local repo
	repo="$(git rev-parse --show-toplevel 2>/dev/null)"
	if [ -n "$repo" ]; then
		printf '\e]1;%s\a' "${repo##*/}"
	else
		printf '\e]1;%s\a' "${PWD##*/}"
	fi
	# OSC 7: report working directory to terminal (for split inherit)
	printf '\e]7;file://%s%s\a' "$HOSTNAME" "$PWD"
}
PROMPT_COMMAND="__update_tab_title${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
