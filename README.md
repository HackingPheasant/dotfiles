# Dotfiles 
This repository contains my personal dotfiles managed with [GNU stow](http://www.gnu.org/software/stow/) as well as (once off) scripts that don't necessarily require their own github repository.

**This repo is not meant to be used verbatim.**<br/> 
These are my personal dotfiles and are intended to work for me and my setup, but best attempts are made to make them as user and distro antagonistic as possible, but this isn't a guarantee either. 
Feel free to create issues or pull requests as you see fit!<br/>
Or you may find one or two interesting things in here, feel free to take and expand on that as your heart desires.

**Table of Contents:**
- [Installation](#installation)
  - [Grabbing a copy](#grabbing-a-copy)
  - [Install](#install)
  - [Shell Configuration](#shell-configuration)
  - [External Configs](#external-configs)
-  [My Setup](#mysetup)
  - [Software](#software)
  - [Scripts](#scripts)
  - [Window Managers and Desktop Environments](#window-managers-and-desktop-enviroments)
    - [Awesome Window Manger (awesomewm)](#awesome-window-manager-awesomewm)
    - [Budgie](#budgie)
- [Other](#other)
- [Licences](#licences)

# Installation
Configs are stored in directories named after the software they belong to, and the contents inside the folders mimic what it would look like from the view point of a users `$HOME` directory.<br/>
So lets take the `vim/` folder as example, if you look inside you will see:
```sh
~ $ ls -1a .dotfiles/vim/
.
..
.vim/
.vimrc
```
When you "[Install](#install)" the configs with your preferred method the end result would end up making our home directory looking like:
```sh
~ $ ls -1a ~
...other files in home dir...
.vim/
.vimrc
...other files in home dir...
```
The way this is setup is to minimise the need to pull in unrelated stuff for something to work, but as with everything in life there are exceptions to this rule, in this case the following directories, [Shell Configurations](#shell-configuration) and [Scripts](#scripts), have other directories depending on them.

## Grabbing a copy
First, clone this repository. 

For example:
```sh
cd ~
git clone --recursive https://github.com/HackingPheasant/dotfiles.git .dotfiles
```
**Note:** If you are missing sub-modules  for what ever reason, you can fix this by running:
```sh
git submodule update --init --recursive
```

## Install
There are various ways you can go about install the configs found in this repository, this can include doing the configs in manually by hand, symlinking them manually or via [GNU Stow](https://www.gnu.org/software/stow/).<br/>
I personally prefer GNU stow as it is very easy to use, so I'll show how using it below, any other way is up to the discretion to the reader. 

Assuming you followed the previous section of the README, then the repository location should be kept somewhere like `$HOME/.dotfiles`.<br/>
Then its as simple as running the following command on the directories of your choice:
```sh
stow <directory>
``` 
If for some reason you decided to keep the this repository in some sub-folder like `%HOME/Projects/dotfiles`.<br/>
Then you will also need to specify a stow target directory in the command, like so:

```sh
stow -t ~/ -D <directory>
```

## Shell Configuration
As mentioned earlier in the README there are two special cases of directories depending on another directory to exist, this is one of them.

Configuring your shell should be an easy and straight forward topic, or at least you'd assume so. In reality this isn't the case, for multiple reasons such as (but not limited to), Shells, Environment variables, distribution-specific compile-time options, the order configs that configs are loaded up (or not loaded at all) changing depending on how you access the shell among a myriad of other small details, which  make dealing with all this a real pain.<br/>
The following is heavily inspired (and based off) [@grawity](https://github.com/grawity) and their answer on this [superuser question](https://superuser.com/a/789499)<sup>[archive.org version](https://web.archive.org/web/20200411090118/https://superuser.com/questions/789448/choosing-between-bashrc-profile-bash-profile-etc/789499)</sup>

The TL;DR is:<br/>
Keep setup as modular and compatible as possible.

Shell stuff gets sourced in this order:
  * `.profile` – *sh* compatible login script, kept minimal
    * `.environ` – *sh* compatible environment variables & umask
    * `.bashrc` if running in bash
      * `.environ` if it wasn't sourced yet
      * `prompt.sh` style shell prompt
      * `alias.sh` load shell aliases and functions 

The `.environ` file is intended to be safe to source from anywhere, including .bashrc – that way it also applies to `ssh $host $command` (which only uses .bashrc and not .profile).<br/>
`prompt.sh` and `alias.sh` make no guarantee to be compatible with other shells (But something I should look into).

## External Configs
These are configurations for devices where sing GNU Stow isn't a viable option but version control of the configurations would still be useful.<br/>
Currently this includes:
  * Switch - Configuration Files for Atmosphere Custom Firmware (CFW), Hekate Bootloader, and other misc homebrew.

# My Setup
**Laptop:** Lenovo ThinkPad E580

## Software
Software setup:
* **OS:** [Solus](https://getsol.us/home/)
* **DE/WM:** [AwesomeWM](https://awesomewm.org/) and occasionally (when the need arises) [Budgie](https://github.com/solus-project/budgie-desktop)
* **Terminal Emulator:** [Kitty](https://sw.kovidgoyal.net/kitty/)
* **Shell:** [Bash](https://www.gnu.org/software/bash/)
* **Browser:** [Firefox](https://www.mozilla.org/firefox/)
* **Password Manager:** [Bitwarden](https://bitwarden.com/)
* **Video and Audio Player:** [mpv](https://mpv.io/)
* **Fonts:**
  * **Terminal:** [Hack](https://github.com/source-foundry/Hack)
  * **Window Titles:** [Clear Sans](https://01.org/clear-sans) Bold
  * **Documents and Interfaces:** [Noto Sans](https://www.google.com/get/noto/) Regular

<!--
Clear up and tidy, but for the time being its fine as is.
-->


## Scripts
Bunch of scripts for various uses. Some are my own, others are sourced from around the internet.

<!--
TODO: Expand this section to include highlights of some of my cooler scripts and reference authorship 
and licences of scripts taken from elsewhere on the internet
-->

## Window Managers and Desktop Environments 
Following is an overview of either how to configure/setup/use a DE or WM similar to my setup. Assume this section will be the most volatile and may not match what I actively use.<br/>
Attempts will be made to keep this updated and current.

### Awesome Window Manager (awesomewm)
TODO

# Budgie
TODO

# Other

**TODO:**
  - Continue configuring awesomewm till I get it into my preferred setup

# Licences
Anything, unless specified otherwise, contained is this repository is available to anybody free of charge, under the terms of MIT License (see [LICENSE](LICENSE)).<br/>
I have attempted my best to acknowledge and credit others works when used or incorporated, but I am only human and am bound to make mistakes, so if I have broken the licensing of content that you have released, or anything else of the sort please feel free to [open an issue](https://github.com/HackingPheasant/dotfiles/issues/new) so we can sort it out.
