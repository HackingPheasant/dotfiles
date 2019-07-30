#!/usr/bin/bash

mkdir -p $HOME/.local/{bin,lib,share}

# Update Default system packages
sudo eopkg update

# Install Build Tools
sudo eopkg install -c system.devel

# Install some programs I find useful
sudo eopkg install git stow rclone mpv vim vlc beets discord riot hub ncdu p7zip
sudo pip3 install internetarchive buku flask pylast

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
