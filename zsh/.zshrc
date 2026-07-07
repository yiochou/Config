source ~/.zsh_prompt

# === Alias ===

alias p="cd ~/Projects"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ll="ls -alh"
alias md="open -a Typora"
alias grep="grep --color=auto"
alias path='echo -e ${PATH//:/\\n}'

alias reload="exec ${SHELL} -l"

alias week="date +%V"
alias timestamp="date +%s"

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# === editor ===
export EDITOR="zed --wait"

# === zoxide (smart cd) ===
eval "$(zoxide init zsh)"

# === yazi wrapper (cd to last dir on exit) ===
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# === Terminal tab title + OSC 7 (for split inherit) ===
__update_tab_title() {
	local repo
	repo="$(git rev-parse --show-toplevel 2>/dev/null)"
	if [ -n "$repo" ]; then
		printf '\e]1;%s\a' "${repo##*/}"
	else
		printf '\e]1;%s\a' "${PWD##*/}"
	fi
	printf '\e]7;file://%s%s\a' "$HOSTNAME" "$PWD"
}
precmd_functions+=(__update_tab_title)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yiochou/projects/SO-101-course/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yiochou/projects/SO-101-course/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yiochou/projects/SO-101-course/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yiochou/projects/SO-101-course/google-cloud-sdk/completion.zsh.inc'; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

