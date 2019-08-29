#!/usr/bin/bash

mkdir -p $HOME/.local/{bin,lib,go,share}

# Update Default system packages
sudo eopkg update

# Install Build Tools
sudo eopkg install -c system.devel

# Install some programs I find useful
sudo eopkg rm gnome-mpv thunderbird transmission rhythmbox
sudo eopkg install git stow rclone mpv vim vlc beets discord riot ncdu p7zip deluge mkvtoolnix mediainfo gtkhash gtkhash-nautilus-extension
sudo pip3 install internetarchive pylast
sudo pip3 install git+git://github.com/geigerzaehler/beets-check.git@master
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

# TODO: 
# - Stow my stuff automatically
# - Have a more modular setup.sh that work on multiple distros
