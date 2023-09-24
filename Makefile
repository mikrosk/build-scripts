TOOL_PREFIX		:= m68k-atari-mintelf
#TOOL_PREFIX		:= m68k-atari-mint
SYS_ROOT		:= $(shell $(TOOL_PREFIX)-gcc -print-sysroot)

ZLIB_VERSION	= 1.3
GEMLIB_BRANCH	= master
SDL_BRANCH		= main
MINTLIB_BRANCH	= dlmalloc
LIBXMP_VERSION	= 4.6.0
LDG_BRANCH		= trunk

ZLIB_URL		= https://www.zlib.net/zlib-$(ZLIB_VERSION).tar.gz
GEMLIB_URL		= https://github.com/freemint/gemlib/archive/refs/heads/$(GEMLIB_BRANCH).tar.gz
SDL_URL			= https://github.com/mikrosk/SDL-1.2/archive/refs/heads/$(SDL_BRANCH).tar.gz
MINTLIB_URL		= https://github.com/mikrosk/mintlib/archive/refs/heads/$(MINTLIB_BRANCH).tar.gz
LIBXMP_URL		= https://github.com/libxmp/libxmp/releases/download/libxmp-4.6.0/libxmp-lite-${LIBXMP_VERSION}.tar.gz
LDG_URL			= https://svn.code.sf.net/p/ldg/code/${LDG_BRANCH}/ldg

default: download build

.PHONY: download
download: zlib.tar.gz gemlib.tar.gz sdl.tar.gz mintlib.tar.gz libxmp.tar.gz

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

.PHONY: build
build: zlib.ok gemlib.ok sdl.ok mintlib.ok libxmp.ok ldg.ok

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
		&& make CROSS_TOOL=${TOOL_PREFIX} \
		&& make CROSS_TOOL=${TOOL_PREFIX} install
	touch $@

libxmp.ok:
	rm -rf libxmp-lite-${LIBXMP_VERSION}
	tar xzf libxmp.tar.gz
	cd libxmp-lite-${LIBXMP_VERSION} \
		&& CFLAGS='-O2 -fomit-frame-pointer -m68000' ./configure --host=${TOOL_PREFIX} --disable-it --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib --bindir=${SYS_ROOT}/usr/bin && make && make install \
		&& make distclean \
		&& CFLAGS='-O2 -fomit-frame-pointer -m68020-60' ./configure --host=${TOOL_PREFIX} --disable-it --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m68020-60 --bindir=${SYS_ROOT}/usr/bin/m68020-60 && make && make install \
		&& make distclean \
		&& CFLAGS='-O2 -fomit-frame-pointer -mcpu=5475' ./configure --host=${TOOL_PREFIX} --disable-it --prefix=${SYS_ROOT}/usr --libdir=${SYS_ROOT}/usr/lib/m5475 --bindir=${SYS_ROOT}/usr/bin/m5475 && make && make install
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

.PHONY: clean
clean:
	rm -f *.ok
	rm -rf zlib-${ZLIB_VERSION} gemlib-${GEMLIB_BRANCH} SDL-1.2-${SDL_BRANCH} mintlib-${MINTLIB_BRANCH} libxmp-lite-${LIBXMP_VERSION} ldg-${LDG_BRANCH}
