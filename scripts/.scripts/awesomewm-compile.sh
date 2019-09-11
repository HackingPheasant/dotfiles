# Install usual build tools
sudo eopkg install -c system.devel
# Install dependencies that arent covered above and that arent on a default install
    sudo eopkg install cmake ruby lua lua-devel luarocks xcb-util xcb-util-devel xcb-util-cursor xcb-util-cursor-devel xcb-util-keysyms xcb-util-keysyms-devel xcb-util-wm xcb-util-wm-devel xcb-util-xrm xcb-util-xrm-devel libxfixes libxfixes-devel xcb-util-xrm xcb-util-xrm-devel libxkbcommon libxkbcommon-devel libstartup-notification libstartup-notification-devel libcairo libcairo-devel pango pango-devel gdk-pixbuf gdk-pixbuf-devel imagemagick imagemagick-devel libxdg-basedir libxdg-basedir-devel xdotool xdotool-devel xcb-proto
# Install asciidoctor
sudo gem install asciidoctor
# Install LGI 
sudo luarocks install lgi
# Install ldoc
sudo luarocks install ldoc
# Install busted
sudo luarocks install busted

# build awesome
git clone https://github.com/awesomeWM/awesome.git
cd awesome
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DSYSCONFDIR=/etc
make
sudo make install
