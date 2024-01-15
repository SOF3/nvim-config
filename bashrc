# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

__BASHRC_START=$(date +%s%N)

set -o vi

shopt -s globstar

export PATH=$(echo $HOME/.asdf/installs/golang/*/packages/bin/ | tr " " ,):$HOME/go/bin:$HOME/.local/bin:$HOME/sys/bin:$PATH
export MANPATH=~/.local/share/man/:$MANPATH

export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL=ignoredups

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


alias vi='nvim -n'
if command -v zoxide >/dev/null; then
	eval "$(zoxide init bash)"
	alias cd=z
else
	alias cd='cd -P'
fi
alias ls='ls -F --color=auto --show-control-chars -A'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias mv='mv -i'
alias cp='cp -i'
alias ta='tmux a -t'
alias clear='env clear && env clear'
alias grep='grep --color=auto'

alias carf='cargo fmt'
alias carl='cargo clippy'
alias carb='cargo build'
alias carr='cargo run'
alias cart='cargo test'

alias myps='ps -A --forest -o user,pid,ppid,stime,tty,time,%cpu,%mem,rss,start,time,comm'
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
color_prompt=yes

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

function push_bashrc_reload_file {
	BASHRC_RELOAD_FILES="$BASHRC_RELOAD_FILES $1"
	source $1
}

if [[ -f $HOME/local.bashrc ]]; then
	push_bashrc_reload_file $HOME/local.bashrc
fi

__BASHRC_CKSUM=$(cksum $BASHRC_RELOAD_FILES)

if [ ! -v PS1_PART_TITLE ]; then
	PS1_PART_TITLE='\[\033]0;$TITLEPREFIX:${PWD//[^[:ascii:]]/?}\007\]'
fi

if [ ! -v PS1_PREFIX ]; then
	declare -A PS1_PREFIX
fi

PS1_PREFIX["execTime"]='\[\033[0m\]\[\033[31m\]$(echo $__COMMAND_LAST_DURATION )ms $(date +%H:%M:%S --date=@$((__COMMAND_START_TIME / 1000)))..$(date +%H:%M:%S) | '

PS1_PART_EXIT_CODE_SUCCESS='true'
PS1_PART_EXIT_CODE_FAILURE='echo \[\033[33m\]"Exit code: $LAST_EXIT_CODE | "'
if [ -v PS1_DO_BEEP ]; then
	PS1_PART_EXIT_CODE_SUCCESS="${PS1_PART_EXIT_CODE_SUCCESS}"'; play -q -n synth 0.08 triangle 5000 vol 0.015 2>/dev/null'
	PS1_PART_EXIT_CODE_FAILURE="${PS1_PART_EXIT_CODE_FAILURE}"'; play -q -n synth 0.3 sin 60000 vol 0.06 2>/dev/null'
fi
PS1_PREFIX["exitCode"]='\[\033[0m\]\[\033[34m\]\[\033[32m\]\[\033[35m\]$(LAST_EXIT_CODE=$? && test $LAST_EXIT_CODE -gt 0 && ('"${PS1_PART_EXIT_CODE_FAILURE}"'; true) || ('"${PS1_PART_EXIT_CODE_SUCCESS}"'; true))'

if [ ! -v PS1_SUFFIX ]; then
	declare -A PS1_SUFFIX
fi
export GIT_PS1_SHOWCOLORHINTS=1 GIT_PS1_SHOWDIRTYSTATE=1
PS1_SUFFIX["git"]='\[\033[36m\]$(__git_ps1)'

PS1="${PS1_PART_TITLE}\\n"
for __next_ps1_part in "${PS1_PREFIX[@]}"; do
	PS1="${PS1}${__next_ps1_part}"
done

if [ ! -v PS1_MAIN ]; then
	PS1_MAIN='\[\033[91m\]\H @ \[\033[32m\]\w'
fi
PS1="${PS1}${PS1_MAIN}"

for __next_ps1_part in "${PS1_SUFFIX[@]}"; do
	PS1="${PS1}${__next_ps1_part}"
done

if [ ! -v PS1_PROMPT_LINE ]; then
	PS1_PROMPT_LINE='\[\033[0m\]$ '
fi

PS1="${PS1}\\n${PS1_PROMPT_LINE}"

function git-root {
	git rev-parse --show-toplevel
}
function go-mod-pkg {
	realpath --relative-to=$(go env GOPATH)/src $(git-root)
}
function git-fmt {
	against=${1:-HEAD}
	cd $(git-root)
	git diff $against --name-only | grep -P '\.go$' | xargs -d '\n' ls -1df 2>/dev/null | xargs gofmt -w
	git diff $against --name-only | grep -P '\.go$' | xargs -d '\n' ls -1df 2>/dev/null | xargs goimports -local $(go-mod-pkg)/ -w
}

if command -v kubectl >/dev/null; then
	source <(kubectl completion bash)
fi

function loop {
	while true; do
		echo "$@"
		eval "$@"
		sleep 1
	done
}

function retry {
	while true; do
		echo "$@"
		eval "$@"
		if [[ $? -eq 0 ]]; then
			break
		fi
		sleep 1
	done
}

echo "complete bashrc ($((($(date +%s%N) - __BASHRC_START) / 1000000))ms)" >&2
