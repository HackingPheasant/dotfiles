# dotfiles

## ```beets/```
## ``` deadbeef/```
## ```git/```
## ```mpv/```
## ```scripts/```
## ```terminal/```
Below is an excert from https://superuser.com/a/789499 (incase the site or link disapper)

Requirements:
* ```~/.profile``` must be compatible with any /bin/sh – this includes bash, dash, ksh, whatever else a distro might choose to use.

* Environment variables must be put in a file that is read by both console logins (i.e. a 'login' shell) and graphical logins (i.e. display managers like GDM, LightDM, or LXDM).

* There is very little point in having both ~/.profile and ~/.bash_profile. If the latter is missing, bash will happily use the former, and any bash-specific lines can be guarded with a check for $BASH or $BASH_VERSION.

* The separation between ```*profile``` and ```*rc``` is that the former is used for 'login' shells, and the latter every time you open a terminal window. However, bash in 'login' mode doesn't source ```~/.bashrc```, therefore ```~/.profile``` needs to do it manually.

The simplest configuration would be:

* Have a ```~/.profile``` that sets all environment variables (except bash-specific ones), perhaps prints a line or two, then sources ````~/.bashrc``` if being run by bash, sticking to sh-compatible syntax otherwise.

```sh
export TZ="Europe/Paris"
export EDITOR="vim"
if [ "$BASH" ]; then
    . ~/.bashrc
fi
uptime
```

* Have a ```~/.bashrc``` that performs any shell-specific setup, guarded with a check for *interactive mode* to avoid breaking things like ```sftp``` on Debian (where bash is compiled with the option to load ```~/.bashrc``` even for non-interactive shells):

```sh
[[ $- == *i* ]] || return 0

PS1='\h \w \$ '

start() { sudo service "$1" start; }
```

However, there's also the problem that certain non-interactive commands (e.g. ```ssh <host> ls```) skip ```~/.profile```, but environment variables would be very useful to them.

* Certain distributions (e.g. Debian) compile their bash with the option to source ```~/.bashrc``` for such non-interactive logins. In this case, I've found it useful to move all environment variables (the ```export ...``` lines) to a separate file,``` ~/.environ```, and to source it from both ```.profile``` and ```.bashrc```, with a guard to avoid doing it twice:

```sh
if ! [ "$PREFIX" ]; then   # or $EDITOR, or $TZ, or ...
    . ~/.environ           # generally any variable that .environ itself would set
fi
```

* Unfortunately, for other distributions (e.g. Arch), I haven't found a very good solution. One possibility is to use the (enabled by default) pam_env PAM module, by putting the following in ```~/.pam_environment```:
```sh
BASH_ENV=./.environ        # not a typo; it needs to be a path, but ~ won't work
```
Then, of course, updating ```~/.environ``` to unset BASH_ENV.

TL;DR:
Shell stuff gets sourced in this order:

  * `.profile` – *sh* compatible login script, kept minimal
      * `.environ` – *sh* compatible environment variables & umask
          * `.environ-$HOSTNAME`
      * `.bashrc` if running in bash
	  * `.environ` if it wasn't sourced yet
          * `.bashrc-$HOSTNAME`
      * `.profile-$HOSTNAME`

The `.environ` file is intended to be safe to source from anywhere, including .bashrc – that way it also applies to `ssh $host $command` (which only uses .bashrc and not .profile).


## ``` vim/```
## ```setup.sh/```
