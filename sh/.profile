# ~/.profile - sh/bash login script
# vim: ft=sh

. ~/.environ

have() { type "$1" >/dev/null 2>&1; }

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

true
