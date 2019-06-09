# ~/.profile - sh/bash login script
# vim: ft=sh

# Source solus stateless config
# the stateless concept - a strict separation between User and System files for easier OS manageability.

if [[ $(lsb_release -i) == *Solus* ]]; then
    source /usr/share/defaults/etc/profile
fi

. ~/.environ

have() { type "$1" >/dev/null 2>&1; }

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# eval
# "typical" use of eval is for running commands that 
# generate shell commands to set environment variables.
eval "$(hub alias -s)"


true
