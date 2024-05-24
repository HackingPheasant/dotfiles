# bashrc -- aliases and functions

unalias -a

# Use the enviroment variables, otherwise use the system
# defaults, they are more likely to already be installed
editor() { command ${EDITOR:-nano} "$@"; }
browser() { command ${BROWSER:-lynx} "$@"; }
pager() { command ${PAGER:-more} "$@"; }

count() { sort "$@" | uniq -c | sort -n -r | pager; }
alias demo='PS1="\\n\\$ "'
alias feh='feh --scale-down'
alias fixperms='chmod -R a=r,u+w,a+x'   #0755 for dir, 0644 for file. https://stackoverflow.com/a/41331598 This is useful especially when copying from NTFS partition to something more linux like. Gets stuff to conform to everything else permission wise (all other perms by default get set by umask 022)
alias gdb='gdb -q'
alias hd='hexdump -C'
alias hex='xxd -p'
alias unhex='xxd -p -r'
alias httpdump="sudo tcpdump -i wlp5s0 -n -s 0 -w - | grep -a -o -E \"Host\\: .*|GET \\/.*\""
alias init='telinit' # for systemd
alias ld_trace='LD_TRACE_LOADED_OBJECTS=1 '
alias ld_auxv_info='LD_SHOW_AUXV=1 '
alias l1='ls -1'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lsd='ls -d */'
alias lsh='ls -d .*'
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
unfuckawesome() { echo 'awesome.restart()' | awesome-client; }
alias unpickle='python -m pickletools'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"' # URL-encode strings
# Open any files passed to vim in tabs
alias vim='vim -p'
# Same as above but with a debugging window opened in the first tab
alias vimd='vim -c Termdebug vim -p'

# dates
alias cal='cal -m'
alias week='date +%V' # Get week number
alias ssdate='date "+%Y%m%d"'
alias sdate='date "+%Y-%m-%d"'
alias mmdate='date "+%Y-%m-%d %H:%M"'
alias mdate='date "+%Y-%m-%d %H:%M:%S %z"'
alias ldate='date "+%A, %B %-d, %Y %H:%M"'
alias mboxdate='date "+%a %b %_d %H:%M:%S %Y"'
alias mimedate='date "+%a, %d %b %Y %H:%M:%S %z"' # RFC 2822
alias isodate='date "+%Y-%m-%dT%H:%M:%S%z"' # ISO 8601

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias ips="ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"


# conditional aliases


# OS-dependent aliases
case $OSTYPE in
	linux-gnu*|cygwin)
                alias df='df -Th'
		alias ls='ls --color=auto'
		alias ip='ip --color=auto'
                alias grep='grep --color=auto'
                alias egrep='egrep --color=auto'
                alias fgrep='fgrep --color=auto'
		;;
	freebsd*)
		alias ls='ls -G'
		alias df='df -h'
		;;
	gnu)
		alias ls='ls --color=auto'
		;;
	netbsd|openbsd*)
		alias df='df -h'
		;;
	*)
		alias df='df -h'
		;;
esac

# misc functions
cat() {
    if [[ $1 == *://* ]]; then
        curl -LsfS "$1"
    else
        command cat "$@"
    fi
}

ytdl() { $HOME/.scripts/youtube-dl/ytdl.sh "$@"; }

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
