# Dotfiles 
This repository contains my personal dotfiles managed with [GNU stow](http://www.gnu.org/software/stow/).

This repo is not meant to be used verbatim. These are my personal dotfiles and they only work for my setup. But if you are crafting your own dotfiles, you might find one or two interesting things in here.

Features:
* Terminal configs -  Setup to try and be as modular and compatible as possible. More Information below.
* [beets](https://beets.io/) configuration
* [deadbeef](http://deadbeef.sourceforge.net/) configuration
* [git](https://git-scm.com/) - git configuration and alias, as well as global ignore file
* [mpv](https://mpv.io/) configuration
* [Nautilus](https://wiki.gnome.org/action/show/Apps/Files) a.k.a Files (Simple File Manager for GNOME) - Currently contains file templetes for use in the right click context menu
* [vim](https://www.vim.org/) configuration
* [x11](https://www.x.org/wiki/) configuration
* [xdg](https://www.freedesktop.org/wiki/Software/xdg-utils/) configuration for mimetypes and user directories
* Fonts
* Scripts - Bunch of scripts for various uses. So are my own, others are sourced from aroud the internet
* External Device Configuratiosn -  These are configurations for devices where sing GNU Stow isn't a viable option but version control of the configurations would still be useful
	* Switch - Configration Files for Atmosphere CFW, Hekate Bootloader, and other misc homebrew.

## Installation
GNU stow is very easy to use. For each directory in this repo, you simply call:
```sh
stow <directory>
```
If dotfiles are kept somewhere like `$HOME/dotfiles`

or 

```sh
stow -t ~/ -D <directory>
```
If dotfiles are kept in some sub folder like `%HOME/Projects/dotfiles`

## Terminal configuration

My terminal configuration is split up into shell specific and none shell specific configurations. 

TL;DR:
Shell stuff gets sourced in this order:

  * `.profile` – *sh* compatible login script, kept minimal
      * `.environ` – *sh* compatible environment variables & umask
      * `.bashrc` if running in bash
	  * `.environ` if it wasn't sourced yet
  * `.xprofile` - X11 login script after `profile`

The `.environ` file is intended to be safe to source from anywhere, including .bashrc – that way it also applies to `ssh $host $command` (which only uses .bashrc and not .profile).

### .xinitrc

Does the same as a display manager's Xsession script would do: sets `$DESKTOP_SESSION`; sources `.profile`, `.xprofile`; loads `.Xresources` and `.Xkbmap`. (Also sets a default background.)

### .xprofile

Loads `.Xresources` and `.Xkbmap` from alternate paths.

Sets up session environment – shared between all DMs and xinit. Currently – kernel keyring, synaptics.

If `$DESKTOP_SESSION` is empty (a bare WM is being started), starts necessary daemons: compositor, notification daemon, polkit agent, screensaver, systemd-logind lock event handler, xbindkeys.

Also starts misc. daemons that are X11-dependent and per-session.

All my terminal configuaritions are heavily based on [this superuser answer](https://superuser.com/a/789499) and [grawity's](https://github.com/grawity) [dotfiles](https://github.com/grawity/dotfiles).
