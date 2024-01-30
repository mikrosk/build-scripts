TOOL_PREFIX		:= m68k-atari-mintelf
#TOOL_PREFIX		:= m68k-atari-mint
SYS_ROOT		:= $(shell $(TOOL_PREFIX)-gcc -print-sysroot)

ZLIB_VERSION	= 1.3.1
GEMLIB_BRANCH	= master
SDL_BRANCH		= main
MINTLIB_BRANCH	= dlmalloc
LIBXMP_VERSION	= 4.6.0
LDG_BRANCH		= trunk
PHYSFS_BRANCH	= m68k-atari-mint
CFLIB_BRANCH	= master
LIBPNG_VERSION	= 1.6.40
SDL_IMAGE_BRANCH= SDL-1.2
LIBCMINI_BRANCH	= master

ZLIB_URL		= https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz
GEMLIB_URL		= https://github.com/freemint/gemlib/archive/refs/heads/${GEMLIB_BRANCH}.tar.gz
SDL_URL			= https://github.com/libsdl-org/SDL-1.2/archive/refs/heads/${SDL_BRANCH}.tar.gz
MINTLIB_URL		= https://github.com/mikrosk/mintlib/archive/refs/heads/${MINTLIB_BRANCH}.tar.gz
LIBXMP_URL		= https://github.com/libxmp/libxmp/releases/download/libxmp-4.6.0/libxmp-lite-${LIBXMP_VERSION}.tar.gz
LDG_URL			= https://svn.code.sf.net/p/ldg/code/${LDG_BRANCH}/ldg
PHYSFS_URL		= https://github.com/pmandin/physfs/archive/refs/heads/${PHYSFS_BRANCH}.tar.gz
CFLIB_URL		= https://github.com/freemint/cflib/archive/refs/heads/${CFLIB_BRANCH}.tar.gz
LIBPNG_URL		= https://download.sourceforge.net/libpng/libpng-${LIBPNG_VERSION}.tar.gz
SDL_IMAGE_URL	= https://github.com/libsdl-org/SDL_image/archive/refs/heads/${SDL_IMAGE_BRANCH}.tar.gz
LIBCMINI_URL	= https://github.com/freemint/libcmini/archive/refs/heads/${LIBCMINI_BRANCH}.tar.gz

default: download build

.PHONY: download
download: zlib.tar.gz gemlib.tar.gz sdl.tar.gz mintlib.tar.gz libxmp.tar.gz physfs.tar.gz cflib.tar.gz libpng.tar.gz sdl_image.tar.gz libcmini.tar.gz

zlib.tar.gz:
	wget -q -O $@ $(ZLIB_URL)

gemlib.tar.gz:
	wget -q -O $@ $(GEMLIB_URL)

sdl.tar.gz:
	wget -q -O $@ $(SDL_URL)

mintlib.tar.gz:
	wget -q -O $@ $(MINTLIB_URL)

libxmp.tar.gz:
	wget -q -O $@ $(LIBXMP_URL)

physfs.tar.gz:
	wget -q -O $@ $(PHYSFS_URL)

cflib.tar.gz:
	wget -q -O $@ $(CFLIB_URL)

libpng.tar.gz:
	wget -q -O $@ $(LIBPNG_URL)

sdl_image.tar.gz:
	wget -q -O $@ $(SDL_IMAGE_URL)

libcmini.tar.gz:
	wget -q -O $@ $(LIBCMINI_URL)

.PHONY: build
build: zlib.ok gemlib.ok ldg.ok sdl.ok mintlib.ok libxmp.ok physfs.ok cflib.ok libpng.ok sdl_image.ok libcmini.ok

zlib.ok:
	rm -rf zlib-${ZLIB_VERSION}
	tar xzf zlib.tar.gz
	cd zlib-${ZLIB_VERSION} \
		&& CFLAGS='-O2 -fomit-frame-pointer -m68000' CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar RANLIB=${TOOL_PREFIX}-ranlib ./configure --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib && make && make install \
		&& make distclean \
		&& CFLAGS='-O2 -fomit-frame-pointer -m68020-60' CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar RANLIB=${TOOL_PREFIX}-ranlib ./configure --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m68020-60 && make && make install \
		&& make distclean \
		&& CFLAGS='-O2 -fomit-frame-pointer -mcpu=5475' CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar RANLIB=${TOOL_PREFIX}-ranlib ./configure --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m5475 && make && make install
	touch $@

gemlib.ok:
	rm -rf gemlib-${GEMLIB_BRANCH}
	tar xzf gemlib.tar.gz
	cd gemlib-${GEMLIB_BRANCH} \
		&& make CROSS_TOOL=${TOOL_PREFIX} PREFIX=${SYS_ROOT}/usr \
		&& make CROSS_TOOL=${TOOL_PREFIX} PREFIX=${SYS_ROOT}/usr install
	touch $@

ldg.ok:
	rm -rf ldg-${LDG_BRANCH}
	svn export ${LDG_URL} ldg-${LDG_BRANCH}
	cd ldg-${LDG_BRANCH}/src/devel \
		&& make -f gcc.mak CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar \
		&& make -f gccm68020-60.mak CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar \
		&& make -f gccm5475.mak CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar \
		&& cp -ra ../../lib/gcc/* ${SYS_ROOT}/usr/lib && cp -ra ../../include ${SYS_ROOT}/usr
	touch $@

sdl.ok:
	rm -rf SDL-1.2-${SDL_BRANCH}
	tar xzf sdl.tar.gz
	cd SDL-1.2-${SDL_BRANCH} \
		&& CFLAGS='-O2 -fomit-frame-pointer -m68000' ./configure --host=${TOOL_PREFIX} --disable-video-opengl --disable-threads --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib --bindir=${SYS_ROOT}/usr/bin && make && make install \
		&& make distclean \
		&& CFLAGS='-O2 -fomit-frame-pointer -m68020-60' ./configure --host=${TOOL_PREFIX} --disable-video-opengl --disable-threads --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m68020-60 --bindir=${SYS_ROOT}/usr/bin/m68020-60 && make && make install \
		&& make distclean \
		&& CFLAGS='-O2 -fomit-frame-pointer -mcpu=5475' ./configure --host=${TOOL_PREFIX} --disable-video-opengl --disable-threads --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m5475 --bindir=${SYS_ROOT}/usr/bin/m5475 && make && make install
	touch $@

mintlib.ok:
	rm -rf mintlib-${MINTLIB_BRANCH}
	tar xzf mintlib.tar.gz
	cd mintlib-${MINTLIB_BRANCH} \
		&& make CROSS_TOOL=${TOOL_PREFIX} WITH_DEBUG_LIB=no SHELL=/bin/bash \
		&& make CROSS_TOOL=${TOOL_PREFIX} WITH_DEBUG_LIB=no SHELL=/bin/bash install
	touch $@

libxmp.ok: libxmp-lite.patch
	rm -rf libxmp-lite-${LIBXMP_VERSION}
	tar xzf libxmp.tar.gz
	cd libxmp-lite-${LIBXMP_VERSION} \
		&& cat ../libxmp-lite.patch | patch -p1 \
		&& CFLAGS='-O2 -fomit-frame-pointer -m68000' ./configure --host=${TOOL_PREFIX} --disable-it --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib --bindir=${SYS_ROOT}/usr/bin && make && make install \
		&& make distclean \
		&& CFLAGS='-O2 -fomit-frame-pointer -m68020-60' ./configure --host=${TOOL_PREFIX} --disable-it --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m68020-60 --bindir=${SYS_ROOT}/usr/bin/m68020-60 && make && make install \
		&& make distclean \
		&& CFLAGS='-O2 -fomit-frame-pointer -mcpu=5475' ./configure --host=${TOOL_PREFIX} --disable-it --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m5475 --bindir=${SYS_ROOT}/usr/bin/m5475 && make && make install
	touch $@

physfs.ok: freemint.cmake
	rm -rf physfs-${PHYSFS_BRANCH}
	tar xzf physfs.tar.gz
	cd physfs-${PHYSFS_BRANCH} \
		&& mkdir build && cd build \
			&& cmake -DCMAKE_TOOLCHAIN_FILE=../../freemint.cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fomit-frame-pointer" -DPHYSFS_BUILD_SHARED=0 -DCMAKE_INSTALL_PREFIX=${SYS_ROOT}/usr -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_INSTALL_BINDIR=bin .. && make VERBOSE=1 && make install \
			&& cd - \
		&& mkdir build020 && cd build020 \
			&& cmake -DCMAKE_TOOLCHAIN_FILE=../../freemint.cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fomit-frame-pointer -m68020-60" -DPHYSFS_BUILD_SHARED=0 -DCMAKE_INSTALL_PREFIX=${SYS_ROOT}/usr -DCMAKE_INSTALL_LIBDIR=lib/m68020-60 -DCMAKE_INSTALL_BINDIR=bin/m68020-60 .. && make VERBOSE=1 && make install \
			&& cd - \
		&& mkdir buildcf && cd buildcf \
			&& cmake -DCMAKE_TOOLCHAIN_FILE=../../freemint.cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fomit-frame-pointer -mcpu=5475" -DPHYSFS_BUILD_SHARED=0 -DCMAKE_INSTALL_PREFIX=${SYS_ROOT}/usr -DCMAKE_INSTALL_LIBDIR=lib/m5475 -DCMAKE_INSTALL_BINDIR=bin/m5475 .. && make VERBOSE=1 && make install \
			&& cd -
	touch $@

cflib.ok:
	rm -rf cflib-${CFLIB_BRANCH}
	tar xzf cflib.tar.gz
	cd cflib-${CFLIB_BRANCH} \
		&& make CROSS_TOOL=${TOOL_PREFIX} PREFIX=${SYS_ROOT}/usr \
		&& make CROSS_TOOL=${TOOL_PREFIX} PREFIX=${SYS_ROOT}/usr install
	touch $@

libpng.ok:
	rm -rf libpng-${LIBPNG_VERSION}
	tar xzf libpng.tar.gz
	cd libpng-${LIBPNG_VERSION} \
		&& CFLAGS='-O2 -fomit-frame-pointer -m68000' ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib --bindir=${SYS_ROOT}/usr/bin && make && make install \
		&& make distclean \
		&& CFLAGS='-O2 -fomit-frame-pointer -m68020-60' ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m68020-60 --bindir=${SYS_ROOT}/usr/bin/m68020-60 && make && make install \
		&& make distclean \
		&& CFLAGS='-O2 -fomit-frame-pointer -mcpu=5475' ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m5475 --bindir=${SYS_ROOT}/usr/bin/m5475 && make && make install
	touch $@

sdl_image.ok:
	rm -rf SDL_image-${SDL_IMAGE_BRANCH}
	tar xzf sdl_image.tar.gz
	cd SDL_image-${SDL_IMAGE_BRANCH} \
		&& PKG_CONFIG_LIBDIR=${SYS_ROOT}/usr/lib/pkgconfig CFLAGS='-O2 -fomit-frame-pointer -m68000' ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib --bindir=${SYS_ROOT}/usr/bin && make && make install \
		&& make distclean \
		&& PKG_CONFIG_LIBDIR=${SYS_ROOT}/usr/lib/m68020-60/pkgconfig CFLAGS='-O2 -fomit-frame-pointer -m68020-60' ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m68020-60 --bindir=${SYS_ROOT}/usr/bin/m68020-60 && make && make install \
		&& make distclean \
		&& PKG_CONFIG_LIBDIR=${SYS_ROOT}/usr/lib/m5475/pkgconfig CFLAGS='-O2 -fomit-frame-pointer -mcpu=5475' ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m5475 --bindir=${SYS_ROOT}/usr/bin/m5475 && make && make install
	touch $@

libcmini.ok:
	rm -rf libcmini-${LIBCMINI_BRANCH}
	tar xzf libcmini.tar.gz
	cd libcmini-${LIBCMINI_BRANCH} \
		&& make CROSSPREFIX=${TOOL_PREFIX}- PREFIX=${SYS_ROOT}/opt/libcmini BUILD_FAST=N BUILD_SOFT_FLOAT=N VERBOSE=yes \
		&& make CROSSPREFIX=${TOOL_PREFIX}- PREFIX=${SYS_ROOT}/opt/libcmini BUILD_FAST=N BUILD_SOFT_FLOAT=N VERBOSE=yes install
	touch $@

.PHONY: clean
clean:
	rm -f *.ok *.tar.gz
	rm -rf zlib-${ZLIB_VERSION} gemlib-${GEMLIB_BRANCH} ldg-${LDG_BRANCH} SDL-1.2-${SDL_BRANCH} mintlib-${MINTLIB_BRANCH} \
		libxmp-lite-${LIBXMP_VERSION} physfs-${PHYSFS_BRANCH} cflib-${CFLIB_BRANCH} libcmini-${LIBCMINI_BRANCH}
