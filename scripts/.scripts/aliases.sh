# bashrc -- aliases and functions

unalias -a

# Use system defaults, they are more likely to already be installed
editor() { command ${EDITOR:-vi} "$@"; }
browser() { command ${BROWSER:-lynx} "$@"; }
browsergui() { command ${BROWSER:-firefox} "$@"; }
pager() { command ${PAGER:-more} "$@"; }

count() { sort "$@" | uniq -c | sort -n -r | pager; }
alias demo='PS1="\\n\\$ "'
alias hd='hexdump -C'
alias hex='xxd -p'
alias unhex='xxd -p -r'
alias init='telinit' # for systemd
alias ls='ls --color=auto'
alias ll='ls --color=auto -l'
alias lla='ls --color=auto -la'
alias logoff='logout'
if [[ $DESKTOP_SESSION ]]; then
	alias logout='env logout'
fi
f() { find . \( -name .git -prune \) , \( -iname "*$1*" "${@:2}" \); }
alias py='python'
alias py2='python2'
alias py3='python3'
rdu() { (( $# )) || set -- */; du -hsc "$@" | awk '$1 !~ /K/ || $2 == "total"' | sort -h; }
alias sudo='sudo ' # for alias expansion in sudo args https://askubuntu.com/a/22043
alias fuck='sudo !!'
alias treedu='tree --du -h'
alias unpickle='python -m pickletools'

# dates

alias ssdate='date "+%Y%m%d"'
alias sdate='date "+%Y-%m-%d"'
alias mmdate='date "+%Y-%m-%d %H:%M"'
alias mdate='date "+%Y-%m-%d %H:%M:%S %z"'
alias ldate='date "+%A, %B %-d, %Y %H:%M"'
alias mboxdate='date "+%a %b %_d %H:%M:%S %Y"'
alias mimedate='date "+%a, %d %b %Y %H:%M:%S %z"' # RFC 2822
alias isodate='date "+%Y-%m-%dT%H:%M:%S%z"' # ISO 8601

# git bisect

alias good='git bisect good'
alias bad='git bisect bad'

# conditional aliases


# OS-dependent aliases

# misc functions
cat() {
	if [[ $1 == *://* ]]; then
		curl -LsfS "$1"
	else
		command cat "$@"
	fi
}


# package management

# service management

if have systemctl && [[ -d /run/systemd/system ]]; then
	start()   { sudo systemctl start "$@";   _status "$@"; }
	stop()    { sudo systemctl stop "$@";    _status "$@"; }
	restart() { sudo systemctl restart "$@"; _status "$@"; }
	reload()  { sudo systemctl reload "$@";  _status "$@"; }
	status()  { SYSTEMD_PAGER='cat' systemctl status -a "$@"; }
	_status() { sudo SYSTEMD_PAGER='cat' systemctl status -a -n0 "$@"; }
	alias enable='sudo systemctl enable'
	alias disable='sudo systemctl disable'
	alias list='systemctl list-units -t path,service,socket --no-legend'
	alias userctl='systemctl --user'
	alias u='systemctl --user'
	alias y='systemctl'
	ustart()   { userctl start "$@";   userctl status -a "$@"; }
	ustop()    { userctl stop "$@";    userctl status -a "$@"; }
	urestart() { userctl restart "$@"; userctl status -a "$@"; }
	ureload()  { userctl reload "$@";  userctl status -a "$@"; }
	alias ulist='userctl list-units -t path,service,socket --no-legend'
	alias lcstatus='loginctl session-status $XDG_SESSION_ID'
	alias tsd='tree /etc/systemd/system'
	cgls() { SYSTEMD_PAGER='cat' systemd-cgls "$@"; }
	usls() { cgls "/user.slice/user-$UID.slice/$*"; }
elif have service; then
	# Debian, other LSB
	start()   { for _s; do sudo service "$_s" start; done; }
	stop()    { for _s; do sudo service "$_s" stop; done; }
	restart() { for _s; do sudo service "$_s" restart; done; }
	status()  { for _s; do sudo service "$_s" status; done; }
	enable()  { for _s; do sudo update-rc.d "$_s" enable; done; }
	disable() { for _s; do sudo update-rc.d "$_s" disable; done; }
fi
