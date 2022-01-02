#!/bin/ksh

doas pkg_add cmake sdl2 libsodium libpng bzip2 gmake

./clone_src.ksh devilutionX https://github.com/diasurgical/devilutionX.git
cd ~/src/ || return
cd devilutionX || return
cmake -S. -Bbuild -DCMAKE_MAKE_PROGRAM=gmake -DCMAKE_BUILD_TYPE=Release
cmake --build build -j $(sysctl -n hw.ncpuonline)