#!/usr/bin/bash

sudo eopkg update
sudo eopkg install -c system.devel
sudo eopkg iistall rclone mpv git vim vlc deadbeef beets stow discord riot hub ncdu p7zip ruby ruby-devel libvirt virt-manager
sudo pip3 install internetarchive buku flask pylast
sudo gem install bundler jekyll
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
