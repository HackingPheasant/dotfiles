#!/usr/bin/bash

mkdir -p $HOME/.local/{bin,lib,go,share}

# Update Default system packages
sudo eopkg upgrade

# Install Build Tools
sudo eopkg install -c system.devel

# Install some programs I find useful
sudo eopkg rm gnome-mpv thunderbird transmission rhythmbox
sudo eopkg install git stow rclone kitty mpv vim vlc beets keyutils fzf jq discord riot ncdu p7zip deluge mkvtoolnix mediainfo gtkhash gtkhash-nautilus-extension libva libva-intel-driver
# BEETS
pip3 -m venv .local/lib/beets-env
source .local/lib/beets-env/bin/activate
pip3 install git+git://github.com/beetbox/beets.git@master
pip3 install requests pylast beets-extrafiles beets-check flask flask_admin flask_api flask_bootstrap flask_paginate flask_wtf
#pip3 install git+git://github.com/agsimmons/beets-audit.git@master

# REDO PIP STUFF
sudo pip3 install internetarchive pylast 
# sudo pip3 install git+git://github.com/geigerzaehler/beets-check.git@master
# Dependicies for buku and bukuserver
# Probley best to do this inside a virtual env but eh...
sudo pip3 install buku arrow flask flask_admin flask_api flask_bootstrap flask_paginate flask_wtf
# Tools for GitHub Pages Blog
sudo eopkg install ruby ruby-devel
sudo gem install bundler jekyll

# Virtualisation
sudo eopkg install libvirt virt-manager
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service


# Manual compile and install mandown with is a markdown viewier
git clone https://github.com/Titor8115/mandown.git && cd mandown && make && \
    sudo install -C -m 755 -o root -g root mandown /usr/bin/mdn

# TODO:
# - Stow my stuff automatically
# - Have a more modular setup.sh that work on multiple distros
# - Modify x-terminal-emulator 
# e.g. sudo ln -sf /usr/bin/kitty /usr/bin/x-terminal-emulator
