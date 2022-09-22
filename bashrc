__BASHRC_START=$(date +%s%N)

set -o vi

export PATH=$HOME/go/bin:$HOME/.local/bin:$HOME/sys/bin:$PATH
export MANPATH=~/.local/share/man/:$MANPATH

. "$HOME/.cargo/env"

export HISTSIZE=
export HISTFILESIZE=

eval $(lesspipe)

alias vi='nvim -n'
alias cd='cd -P'
alias ls='ls -F --color=auto --show-control-chars -A'
alias mv='mv -i'
alias cp='cp -i'
alias ta='tmux a -t'
alias clear='env clear && env clear'

alias myps='ps -A --forest -o user,pid,ppid,stime,tty,time,%cpu,%pem,rss,start,time,comm'
function p {
	if [[ $# -eq 0 ]]; then
		myps
	else
		myps | grep $1
	fi
}

export TERM=xterm-256color
if [[ -v TMUX ]]; then
	export TERM=tmux-256color
fi

export GPG_TTY=$(tty)
export VISUAL=nvim
export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function px {
	for v in ALL_PROXY HTTPS_PROXY HTTP_PROXY all_proxy https_proxy http_proxy; do
		eval export $v=socks5://127.0.0.1:55555
	done
}

function pxh {
	for v in ALL_PROXY HTTPS_PROXY HTTP_PROXY all_proxy https_proxy http_proxy; do
		eval export $v=socks5h://127.0.0.1:55555
	done
}

function ux {
	for v in ALL_PROXY HTTPS_PROXY HTTP_PROXY all_proxy https_proxy http_proxy; do
		eval unset $v
	done
}

function get-name {
	filename="$(basename -- "$1")"
	simplename="${filename%.*}"
	echo $simplename
}
function get-ext {
	filename="$(basename -- "$1")"
	extension="${filename##*.}"
	echo $extension
}

PS1='\[\033]0;$TITLEPREFIX:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[0m\]\[\033[34m\]\[\033[32m\]\[\033[35m\]$(LAST_EXIT_CODE=$? && test $LAST_EXIT_CODE -gt 0 && echo \[\033[33m\]"Exit code: $LAST_EXIT_CODE | ")\[\033[0m\]\[\033[31m\]$(echo $__COMMAND_LAST_DURATION )ms $(date +%H:%M:%S --date=@$((__COMMAND_START_TIME / 1000)))..$(date +%H:%M:%S) | \[\033[91m\]\H @ \[\033[32m\]\w\[\033[36m\]$(__git_ps1)\[\033[0m\]\n$ '
trap '{
	if [ "$__DEBUG_TRAP_ONCE" == true ]; then
		__COMMAND_START_TIME=$(($(date +%s%N) / 1000000));
		__DEBUG_TRAP_ONCE=false
	fi
}' DEBUG

if [[ $__HAS_ADDED_PROMPT != 1 ]]; then
	__HAS_ADDED_PROMPT=1
	PROMPT_COMMAND='history -a; {
		__NEW_BASHRC_CKSUM=$(cksum $BASHRC_RELOAD_FILES)
		if [[ $__BASHRC_CKSUM != $(cksum $BASHRC_RELOAD_FILES) ]]; then
			source $HOME/.bashrc
		fi ;
		__COMMAND_LAST_DURATION=$((
			$((
				$(date +%s%N) / 1000000
			)) - __COMMAND_START_TIME
		)) ;
		__DEBUG_TRAP_ONCE=true
	}; '
fi
__COMMAND_START_TIME=$(($(date +%s%N) / 1000000));

BASHRC_RELOAD_FILES=$HOME/.bashrc

if [[ -f $HOME/local.bashrc ]]; then
	BASHRC_RELOAD_FILES="$BASHRC_RELOAD_FILES $HOME/local.bashrc"
	source $HOME/local.bashrc
fi

__BASHRC_CKSUM=$(cksum $BASHRC_RELOAD_FILES)

function git-root {
	git rev-parse --show-toplevel
}
function go-mod-pkg {
	realpath --relative-to=$(go env GOPATH)/src $(git-root)
}
function git-fmt {
	against=${1:-HEAD}
	cd $(git-root)
	git diff $against --name-only | grep -P '\.go$' | xargs gofmt -w
	git diff $against --name-only | grep -P '\.go$' | xargs goimports -local $(go-mod-pkg)/ -w
}

if command -v kubectl >/dev/null; then
	source <(kubectl completion bash)
fi

function loop {
	while true; do
		echo "$@"
		eval "$@"
	done
}

function retry {
	while true; do
		echo "$@"
		eval "$@"
		if [[ $? -eq 0 ]]; then
			break
		fi
	done
}

echo "complete bashrc ($((($(date +%s%N) - __BASHRC_START) / 1000000))ms)" >&2
