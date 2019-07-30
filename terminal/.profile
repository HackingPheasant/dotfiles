# ~/.profile - sh/bash login script
# vim: ft=sh

if [[ $(lsb_release -i) == *Solus* ]]; then
	# Source solus stateless config
	# the stateless concept - a strict separation between User and System files for easier OS manageability.
	source /usr/share/defaults/etc/profile
fi

. ~/.environ

have() { type "$1" >/dev/null 2>&1; }

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

true
