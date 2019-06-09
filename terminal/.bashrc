# ~/.bashrc - bash interactive startup file
# vim: ft=sh

# Source solus stateless config
# the stateless concept - a strict separation between User and System files for easier OS manageability.

if [[ $(lsb_release -i) == *Solus* ]]; then
    source /usr/share/defaults/etc/profile
fi

have() { command -v "$1" >&/dev/null; }

if [[ ! $PREFIX ]]; then
	. ~/.environ
	# this currently happens when:
	# - `sudo -s` preserves $HOME but cleans other envvars
	# - bash is built with #define SSH_SOURCE_BASHRC (e.g. Debian)
	#(. lib.bash && warn "had to load .environ from .bashrc")
fi

if [[ $TERM == @(screen|tmux|xterm) ]]; then
	OLD_TERM="$TERM"
	TERM="$TERM-256color"
fi

export GPG_TTY=$(tty)
export -n VTE_VERSION

if [[ $SSH_CLIENT ]]; then
	SELF=${SSH_CLIENT%% *}
fi

### Interactive options

[[ $- == *i* ]] || return 0

shopt -s autocd 2>/dev/null     # assume 'cd' when trying to exec a directory
shopt -s cdspell                # Autocorrect typos in path names when using `cd`
shopt -s checkjobs 2> /dev/null # print job status on exit
shopt -s checkwinsize           # update $ROWS/$COLUMNS after command

shopt -s cmdhist		# store multi-line commands as single history entry
shopt -s histappend		# append to $HISTFILE on exit, rather than overwriting it
shopt -s histreedit             # allow re-editing failed history subst

HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth
HISTIGNORE='?:??'               # don't save trivial one and two character commands
HISTTIMEFORMAT="(%F %T) "

. ~/.scripts/prompt.sh
. ~/.scripts/aliases.sh

true
