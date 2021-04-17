mkdir ~/GCC10
cd ~/GCC10
wget https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz
tar -xf gcc-10.2.0.tar.xz
cd gcc-10.2.0
contrib/download_prerequisites
cd ..
mkdir build
cd build
export triplet=x86_64-solus-linux
# Set sane and safe flags for a compiler build
export CFLAGS="-mtune=generic -march=x86-64 -g1 -O3 -fstack-protector -pipe -fPIC -Wl,-z,relro -Wl,-z,now -Wl,-z,max-page-size=0x1000"
export CXXFLAGS="-mtune=generic -march=x86-64 -g1 -O3 -pipe -fPIC -Wl,-z,max-page-size=0x1000"
export CFLAGS_FOR_TARGET=${CFLAGS}
export CC=${triplet}-gcc
export CXX=${triplet}-g++
../gcc-10.2.0/configure -v \
                        --prefix=/usr/local/gcc-10.2.0 \
	                --with-system-zlib \
	                --enable-cet \
                        --enable-checcking=release \
	                --enable-default-ssp \
	                --enable-shared \
	                --enable-threads=posix \
	                --enable-gnu-indirect-function \
	                --enable-__cxa_atexit \
	                --enable-plugin \
	                --enable-gold \
	                --enable-ld=default \
	                --enable-clocale=gnu \
	                --disable-multilib \
	                --with-gcc-major-version-only \
	                --with-arch_32=i686 \
	                --enable-linker-build-id  \
	                --with-linker-hash-style=gnu \
	                --with-gnu-ld \
	                --build=${triplet} \
                        --host=${triplet} \
	                --target=${triplet} \
	                --enable-languages=c,c++,fortran \
                        --program-suffix=-10.2
../gcc-10.2.0/contrib/test_summary
make -j 8
sudo make install-strip
