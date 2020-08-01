git clone --depth=1 https://github.com/z0z0z/mf-install.git
cd mf-install
export WINEPREFIX=/home/${USER}/.steam/steam/steamapps/compatdata/683320/pfx
export PROTON="/home/${USER}/.steam/steam/steamapps/common/Proton 5.0"
./mf-install.sh -proton
cd ..
echo "Add -PROTON_NO_ESYNC=1 -PROTON_USE_WINED3D=1 into launch options"
