TOOL_PREFIX		:= m68k-atari-mintelf
#TOOL_PREFIX		:= m68k-atari-mint
SYS_ROOT		:= $(shell $(TOOL_PREFIX)-gcc -print-sysroot)
JOBS			:= -j$(shell nproc)
MULTILIBS		:= $(shell $(TOOL_PREFIX)-gcc -print-multi-lib | grep -v mshort | tr ';' ':')

# per multilib: $$libdir/$$bindir are the install directories, $$flags the gcc flags
ML_SETUP		= dir=$${ml%%:*}; dir=$${dir\#.}; libdir=${SYS_ROOT}/usr/lib$${dir:+/$$dir}; bindir=${SYS_ROOT}/usr/bin$${dir:+/$$dir}; flags=$$(echo $${ml\#*:} | sed 's/@/ -/g; s/^ //');

ZLIB_VERSION	= 1.3.2
GEMLIB_BRANCH	= master
SDL_BRANCH		= main
LIBXMP_VERSION	= 4.7.3
LDG_BRANCH		= trunk
PHYSFS_BRANCH	= m68k-atari-mint
CFLIB_BRANCH	= master
LIBPNG_VERSION	= 1.6.58
SDL_IMAGE_BRANCH= SDL-1.2
USOUND_BRANCH	= main
LIBCMINI_BRANCH	= master
SDL_MIXER_BRANCH= SDL-1.2
ASAP_VERSION	= 8.0.0
MPG123_VERSION	= 1.33.7
OSMESA_VERSION	= 7.7.1
NFM_VERSION		= 0.4.0

ZLIB_URL		= https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz
GEMLIB_URL		= https://github.com/freemint/gemlib/archive/refs/heads/${GEMLIB_BRANCH}.tar.gz
SDL_URL			= https://github.com/libsdl-org/SDL-1.2/archive/refs/heads/${SDL_BRANCH}.tar.gz
LIBXMP_URL		= https://github.com/libxmp/libxmp/releases/download/libxmp-${LIBXMP_VERSION}/libxmp-${LIBXMP_VERSION}.tar.gz
LIBXMP_LITE_URL	= https://github.com/libxmp/libxmp/releases/download/libxmp-${LIBXMP_VERSION}/libxmp-lite-${LIBXMP_VERSION}.tar.gz
LDG_URL			= https://svn.code.sf.net/p/ldg/code/${LDG_BRANCH}/ldg
PHYSFS_URL		= https://github.com/pmandin/physfs/archive/refs/heads/${PHYSFS_BRANCH}.tar.gz
CFLIB_URL		= https://github.com/freemint/cflib/archive/refs/heads/${CFLIB_BRANCH}.tar.gz
LIBPNG_URL		= https://download.sourceforge.net/libpng/libpng-${LIBPNG_VERSION}.tar.gz
SDL_IMAGE_URL	= https://github.com/libsdl-org/SDL_image/archive/refs/heads/${SDL_IMAGE_BRANCH}.tar.gz
USOUND_URL		= https://raw.githubusercontent.com/mikrosk/usound/${USOUND_BRANCH}/usound.h
LIBCMINI_URL	= https://github.com/freemint/libcmini/archive/refs/heads/${LIBCMINI_BRANCH}.tar.gz
SDL_MIXER_URL	= https://github.com/libsdl-org/SDL_mixer/archive/refs/heads/${SDL_MIXER_BRANCH}.tar.gz
ASAP_URL		= https://sourceforge.net/projects/asap/files/asap/${ASAP_VERSION}/asap-${ASAP_VERSION}.tar.gz/download
MPG123_URL		= https://sourceforge.net/projects/mpg123/files/mpg123/${MPG123_VERSION}/mpg123-${MPG123_VERSION}.tar.bz2/download
OSMESA_URL		= https://archive.mesa3d.org/older-versions/7.x/${OSMESA_VERSION}/MesaLib-${OSMESA_VERSION}.tar.bz2
NFM_URL			= https://framagit.org/nokturnal/nfm/-/archive/${NFM_VERSION}/nfm-${NFM_VERSION}.tar.gz

default: download build

.PHONY: download
download: zlib.tar.gz gemlib.tar.gz usound.h osmesa.tar.bz2 sdl.tar.gz libxmp.tar.gz libxmp-lite.tar.gz physfs.tar.gz cflib.tar.gz libpng.tar.gz sdl_image.tar.gz libcmini.tar.gz sdl_mixer.tar.gz asap.tar.gz mpg123.tar.bz2 nfm.tar.gz

zlib.tar.gz:
	wget -q -O $@ $(ZLIB_URL) || { rm -f $@; exit 1; }

gemlib.tar.gz:
	wget -q -O $@ $(GEMLIB_URL) || { rm -f $@; exit 1; }

usound.h:
	wget -q -O $@ $(USOUND_URL) || { rm -f $@; exit 1; }

osmesa.tar.bz2:
	wget -q -O $@ $(OSMESA_URL) || { rm -f $@; exit 1; }

sdl.tar.gz:
	wget -q -O $@ $(SDL_URL) || { rm -f $@; exit 1; }

libxmp.tar.gz:
	wget -q -O $@ $(LIBXMP_URL) || { rm -f $@; exit 1; }

libxmp-lite.tar.gz:
	wget -q -O $@ $(LIBXMP_LITE_URL) || { rm -f $@; exit 1; }

physfs.tar.gz:
	wget -q -O $@ $(PHYSFS_URL) || { rm -f $@; exit 1; }

cflib.tar.gz:
	wget -q -O $@ $(CFLIB_URL) || { rm -f $@; exit 1; }

libpng.tar.gz:
	wget -q -O $@ $(LIBPNG_URL) || { rm -f $@; exit 1; }

sdl_image.tar.gz:
	wget -q -O $@ $(SDL_IMAGE_URL) || { rm -f $@; exit 1; }

libcmini.tar.gz:
	wget -q -O $@ $(LIBCMINI_URL) || { rm -f $@; exit 1; }

sdl_mixer.tar.gz:
	wget -q -O $@ $(SDL_MIXER_URL) || { rm -f $@; exit 1; }

asap.tar.gz:
	wget -q -O $@ $(ASAP_URL) || { rm -f $@; exit 1; }

mpg123.tar.bz2:
	wget -q -O $@ $(MPG123_URL) || { rm -f $@; exit 1; }

nfm.tar.gz:
	wget -q -O $@ $(NFM_URL) || { rm -f $@; exit 1; }

.PHONY: build
build: zlib.ok gemlib.ok ldg.ok usound.ok osmesa.ok sdl.ok libxmp.ok libxmp-lite.ok physfs.ok cflib.ok libpng.ok sdl_image.ok libcmini.ok sdl_mixer.ok asap.ok mpg123.ok nfm.ok

zlib.ok:
	rm -rf zlib-${ZLIB_VERSION}
	tar xzf zlib.tar.gz
	sed -i -e 's/CFLAGS="$${CFLAGS--O3} -fPIC"/CFLAGS="$${CFLAGS--O3}"/g;' zlib-${ZLIB_VERSION}/configure
	cd zlib-${ZLIB_VERSION} && for ml in $(MULTILIBS); do $(ML_SETUP) \
		CFLAGS="-O2 -fomit-frame-pointer $$flags" CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar RANLIB=${TOOL_PREFIX}-ranlib ./configure --prefix=${SYS_ROOT}/usr --libdir=$$libdir \
			&& make $(JOBS) && make install && make distclean || exit 1; \
	done
	touch $@

gemlib.ok:
	rm -rf gemlib-${GEMLIB_BRANCH}
	tar xzf gemlib.tar.gz
	cd gemlib-${GEMLIB_BRANCH} \
		&& make $(JOBS) CROSS_TOOL=${TOOL_PREFIX} DESTDIR=${SYS_ROOT} PREFIX=/usr V=1 \
		&& make CROSS_TOOL=${TOOL_PREFIX} DESTDIR=${SYS_ROOT} PREFIX=/usr V=1 install
	touch $@

ldg.ok:
	rm -rf ldg-${LDG_BRANCH}
	svn export ${LDG_URL} ldg-${LDG_BRANCH}
	cd ldg-${LDG_BRANCH}/src/devel \
		&& make $(JOBS) -f gcc.mak CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar \
		&& make $(JOBS) -f gccm68020-60.mak CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar \
		&& make $(JOBS) -f gccm5475.mak CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar \
		&& cp -ra ../../lib/gcc/* ${SYS_ROOT}/usr/lib && cp -ra ../../include ${SYS_ROOT}/usr
	touch $@

usound.ok:
	install -C -m 644 usound.h ${SYS_ROOT}/usr/include
	touch $@

osmesa.ok: osmesa.patch
	rm -rf Mesa-${OSMESA_VERSION}
	tar xjf osmesa.tar.bz2
	cd Mesa-${OSMESA_VERSION} && cat ../osmesa.patch | patch -p1 && for ml in $(MULTILIBS); do $(ML_SETUP) \
		CFLAGS="-O2 -fomit-frame-pointer $$flags" CXXFLAGS="-O2 -fomit-frame-pointer $$flags" ./configure --host=${TOOL_PREFIX} --without-x --enable-static --disable-shared --with-driver=osmesa --disable-egl --disable-glu --disable-glw --disable-gallium --prefix=${SYS_ROOT}/usr --libdir=$$libdir \
			&& make $(JOBS) && make install && ${TOOL_PREFIX}-ranlib $$libdir/libOSMesa.a && make distclean || exit 1; \
	done
	touch $@

sdl.ok:
	rm -rf SDL-1.2-${SDL_BRANCH}
	tar xzf sdl.tar.gz
	cd SDL-1.2-${SDL_BRANCH} && for ml in $(MULTILIBS); do $(ML_SETUP) \
		CFLAGS="-O2 -fomit-frame-pointer $$flags" ./configure --host=${TOOL_PREFIX} --disable-threads --prefix=${SYS_ROOT}/usr --libdir=$$libdir --bindir=$$bindir \
			&& make $(JOBS) && make install && make distclean || exit 1; \
	done
	touch $@

libxmp.ok: libxmp.patch
	rm -rf libxmp-${LIBXMP_VERSION}
	tar xzf libxmp.tar.gz
	cd libxmp-${LIBXMP_VERSION} && cat ../libxmp.patch | patch -p1 && for ml in $(MULTILIBS); do $(ML_SETUP) \
		CFLAGS="-O2 -fomit-frame-pointer $$flags" ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=$$libdir --bindir=$$bindir \
			&& make $(JOBS) && make install && make distclean || exit 1; \
	done
	touch $@

libxmp-lite.ok: libxmp-lite.patch
	rm -rf libxmp-lite-${LIBXMP_VERSION}
	tar xzf libxmp-lite.tar.gz
	cd libxmp-lite-${LIBXMP_VERSION} && cat ../libxmp-lite.patch | patch -p1 && for ml in $(MULTILIBS); do $(ML_SETUP) \
		CFLAGS="-O2 -fomit-frame-pointer $$flags" ./configure --host=${TOOL_PREFIX} --disable-it --prefix=${SYS_ROOT}/usr --libdir=$$libdir --bindir=$$bindir \
			&& make $(JOBS) && make install && make distclean || exit 1; \
	done
	touch $@

physfs.ok: freemint-${TOOL_PREFIX}.cmake Platform/FreeMiNT.cmake
	rm -rf physfs-${PHYSFS_BRANCH}
	tar xzf physfs.tar.gz
	cd physfs-${PHYSFS_BRANCH} && for ml in $(MULTILIBS); do $(ML_SETUP) \
		rm -rf build && mkdir build && cd build \
			&& cmake -DCMAKE_TOOLCHAIN_FILE=../../freemint-${TOOL_PREFIX}.cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fomit-frame-pointer $$flags" -DPHYSFS_BUILD_SHARED=0 -DCMAKE_INSTALL_PREFIX=${SYS_ROOT}/usr -DCMAKE_INSTALL_LIBDIR=$$libdir -DCMAKE_INSTALL_BINDIR=$$bindir .. \
			&& make $(JOBS) VERBOSE=1 && make install && cd .. || exit 1; \
	done
	touch $@

cflib.ok:
	rm -rf cflib-${CFLIB_BRANCH}
	tar xzf cflib.tar.gz
	cd cflib-${CFLIB_BRANCH} \
		&& make $(JOBS) CROSS_TOOL=${TOOL_PREFIX} DESTDIR=${SYS_ROOT} PREFIX=/usr V=1 \
		&& make CROSS_TOOL=${TOOL_PREFIX} DESTDIR=${SYS_ROOT} PREFIX=/usr V=1 install
	touch $@

libpng.ok:
	rm -rf libpng-${LIBPNG_VERSION}
	tar xzf libpng.tar.gz
	cd libpng-${LIBPNG_VERSION} && for ml in $(MULTILIBS); do $(ML_SETUP) \
		CFLAGS="-O2 -fomit-frame-pointer $$flags" ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=$$libdir --bindir=$$bindir \
			&& make $(JOBS) && make install && make distclean || exit 1; \
	done
	touch $@

sdl_image.ok:
	rm -rf SDL_image-${SDL_IMAGE_BRANCH}
	tar xzf sdl_image.tar.gz
	cd SDL_image-${SDL_IMAGE_BRANCH} && for ml in $(MULTILIBS); do $(ML_SETUP) \
		PKG_CONFIG_LIBDIR=$$libdir/pkgconfig CFLAGS="-O2 -fomit-frame-pointer $$flags" ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=$$libdir --bindir=$$bindir \
			&& make $(JOBS) && make install && make distclean || exit 1; \
	done
	touch $@

libcmini.ok:
	rm -rf libcmini-${LIBCMINI_BRANCH}
	tar xzf libcmini.tar.gz
ifeq ($(TOOL_PREFIX),m68k-atari-mintelf)
	cd libcmini-${LIBCMINI_BRANCH} \
		&& make $(JOBS) PREFIX=${SYS_ROOT}/opt/libcmini BUILD_SOFT_FLOAT=N COMPILE_ELF=Y VERBOSE=yes \
		&& make PREFIX=${SYS_ROOT}/opt/libcmini BUILD_SOFT_FLOAT=N COMPILE_ELF=Y VERBOSE=yes install
else
	cd libcmini-${LIBCMINI_BRANCH} \
		&& make $(JOBS) PREFIX=${SYS_ROOT}/opt/libcmini BUILD_FAST=N BUILD_SOFT_FLOAT=N COMPILE_ELF=N VERBOSE=yes \
		&& make PREFIX=${SYS_ROOT}/opt/libcmini BUILD_FAST=N BUILD_SOFT_FLOAT=N COMPILE_ELF=N VERBOSE=yes install
endif
	touch $@

sdl_mixer.ok:
	rm -rf SDL_mixer-${SDL_MIXER_BRANCH}
	tar xzf sdl_mixer.tar.gz
	cd SDL_mixer-${SDL_MIXER_BRANCH} && for ml in $(MULTILIBS); do $(ML_SETUP) \
		PKG_CONFIG_LIBDIR=$$libdir/pkgconfig CFLAGS="-O2 -fomit-frame-pointer $$flags" LDFLAGS="$$flags" ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=$$libdir --bindir=$$bindir \
			--disable-music-mod --disable-music-timidity-midi --disable-music-fluidsynth-midi --disable-music-ogg --disable-music-flac --disable-music-mp3 \
			&& make $(JOBS) && make install && make distclean || exit 1; \
	done
	touch $@

asap.ok:
	rm -rf asap-${ASAP_VERSION}
	tar xzf asap.tar.gz
	cd asap-${ASAP_VERSION} && for ml in $(MULTILIBS); do $(ML_SETUP) \
		make $(JOBS) CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar CFLAGS="-O2 -fomit-frame-pointer $$flags" prefix=${SYS_ROOT}/usr libdir=$$libdir bindir=$$bindir \
			&& make CC=${TOOL_PREFIX}-gcc AR=${TOOL_PREFIX}-ar CFLAGS="-O2 -fomit-frame-pointer $$flags" prefix=${SYS_ROOT}/usr libdir=$$libdir bindir=$$bindir install \
			&& rm asap.o libasap.a asapconv || exit 1; \
	done
	touch $@

mpg123.ok:
	rm -rf mpg123-${MPG123_VERSION}
	tar xjf mpg123.tar.bz2
	cd mpg123-${MPG123_VERSION} && for ml in $(MULTILIBS); do $(ML_SETUP) \
		case "$$flags" in *m68020-60*|*mcpu=5475*) cpu=generic_fpu;; *) cpu=generic_nofpu;; esac; \
		CFLAGS="-O2 -fomit-frame-pointer $$flags" ./configure --host=${TOOL_PREFIX} --prefix=${SYS_ROOT}/usr --libdir=$$libdir --with-cpu=$$cpu \
			--disable-components --enable-libmpg123 --enable-network=no --disable-gapless --disable-feeder --disable-new-huffman --disable-messages --disable-equalizer --disable-32bit --disable-real --disable-feature_report --disable-largefile --with-seektable=0 \
			&& make $(JOBS) && make install && make distclean || exit 1; \
	done
	touch $@

# FMST doesn't compile: OT_OPN and CO_YM2203 are undefined
# C17 -> C11: gcc 7 has no -std=c17 and nFM uses nothing beyond C11
nfm.ok: freemint-${TOOL_PREFIX}.cmake Platform/FreeMiNT.cmake nfm.patch
	rm -rf nfm-${NFM_VERSION}
	tar xzf nfm.tar.gz
	cd nfm-${NFM_VERSION} && cat ../nfm.patch | patch -p1 \
		&& grep -rlZ --include=CMakeLists.txt --include='*.cmake' AtariTOS . | xargs -0 sed -i 's/AtariTOS/FreeMiNT/g; s/CMAKE_C_STANDARD 17/CMAKE_C_STANDARD 11/; s/-std=c17/-std=c11/' \
		&& for ml in $(MULTILIBS); do $(ML_SETUP) \
		case "$$flags" in "") cpu=68000;; "-m68020-60") cpu=68020-60;; "-mfastcall") cpu=68000;; "-m68020-60 -mfastcall") cpu=68020-60;; *) continue;; esac; \
		case "$$flags" in *-mfastcall*) fastcall=ON;; *) fastcall=OFF;; esac; \
		rm -rf build && mkdir build && cd build \
			&& cmake -DCMAKE_TOOLCHAIN_FILE=../../freemint-${TOOL_PREFIX}.cmake -DCMAKE_BUILD_TYPE=Final -DM68K_CPU=$$cpu -DM68K_FASTCALL=$$fastcall -DTOS_CRT=stdlib \
				-DCMAKE_MODULE_PATH=$$PWD/../cmake.inc/modules -DCMAKE_ASM_VASM_COMPILER_ELF=$(if $(filter %mintelf,$(TOOL_PREFIX)),TRUE,FALSE) \
				-DNFM_ENABLE_DRIVER_NOKTURNFM=ON -DNFM_ENABLE_DRIVER_SB=ON -DNFM_ENABLE_DRIVER_NULL=ON -DNFM_ENABLE_DRIVER_NULL_NATFEATS_EXTENSION=ON -DNFM_ENABLE_DRIVER_OPLL=ON \
				-DNFM_ENABLE_DRIVER_RW_OPL3_EXPRESS=ON -DNFM_ENABLE_DRIVER_OPL3DUO=ON -DNFM_ENABLE_DRIVER_OPLXLPT=ON -DNFM_ENABLE_DRIVER_NUKED_OPL3=OFF -DNFM_ENABLE_DRIVER_FMST=OFF \
				-DCMAKE_INSTALL_PREFIX=${SYS_ROOT}/usr -DCMAKE_INSTALL_INCLUDEDIR=include/nfm .. \
			&& make $(JOBS) nfm iofs allocators sysaudio \
			&& cmake --install . --component libraries && cmake --install . --component headers && cmake --install . --component Unspecified \
			&& cd .. || exit 1; \
	done
	touch $@

.PHONY: clean
clean:
	rm -f *.ok *.tar.gz *.tar.bz2
	rm -rf zlib-${ZLIB_VERSION} gemlib-${GEMLIB_BRANCH} ldg-${LDG_BRANCH} usound.h SDL-1.2-${SDL_BRANCH} \
		libxmp-${LIBXMP_VERSION} libxmp-lite-${LIBXMP_VERSION} physfs-${PHYSFS_BRANCH} cflib-${CFLIB_BRANCH} libpng-${LIBPNG_VERSION} SDL_image-${SDL_IMAGE_BRANCH} libcmini-${LIBCMINI_BRANCH} \
		SDL_mixer-${SDL_MIXER_BRANCH} asap-${ASAP_VERSION} mpg123-${MPG123_VERSION} Mesa-${OSMESA_VERSION} nfm-${NFM_VERSION}
