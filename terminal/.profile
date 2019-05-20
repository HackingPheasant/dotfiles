# ~/.profile - sh/bash login script
# vim: ft=sh

. ~/.environ

have() { type "$1" >/dev/null 2>&1; }

if  [ -f ~/.profile-$HOSTNAME ]; then
	. ~/.profile-$HOSTNAME
fi

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# eval
# "typical" use of eval is for running commands that 
# generate shell commands to set environment variables.
eval "$(hub alias -s)"


true
