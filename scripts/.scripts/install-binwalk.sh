cd ~ && mkdir -P GitHub && cd GitHub
# Having trouble compiling mtd-utils on solus

# Install dependices
# I am not able to instal all of the listed
# dependices on solus so I took my best go
# at installing as much as possible
sudo eopkg it python-devel python3-devel lzop lzo lzo-devel capstone capstone-devel p7zip e2fsprogs e2fsprogs-devel
sudo pip3 install pylzma nose coverage pycrypto pyqtgraph capstone cstruct python-lzo matplotlib
wget -O - http://my.smithmicro.com/downloads/files/stuffit520.611linux-i386.tar.gz | tar -zxv bin/unstuff && mv bin/unstuff ~/.local/bin/ && rmdir bin/
sudo pip3 install git+git://github.com/devttys0/yaffshiv.git@master
sudo pip3 install git+git://github.com/jrspruitt/ubi_reader.git@master
sudo pip3 install git+git://github.com/sviehb/jefferson.git@master

# Install the actual program
sudo pip3 install git+git://github.com/devttys0/binwalk.git@master
