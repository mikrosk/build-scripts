# the name of the target operating system
set(CMAKE_SYSTEM_NAME FreeMiNT)

# which compilers to use for C and C++
set(CMAKE_C_COMPILER   m68k-atari-mintelf-gcc)
set(CMAKE_CXX_COMPILER m68k-atari-mintelf-g++)

# where is the target environment located
set(CMAKE_FIND_ROOT_PATH /home/mikro/gnu-tools/m68000/m68k-atari-mintelf/sys-root)

# adjust the default behavior of the FIND_XXX() commands:
# search programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# search headers and libraries in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(BUILD_SHARED_LIBS OFF)
