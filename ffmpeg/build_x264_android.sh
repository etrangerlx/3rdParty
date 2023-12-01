#!/bin/bash

archbit=32
if [ $archbit -eq 32 ];then
echo "build for 32bit"
#32bit
ABI='armeabi-v7a'
CPU='armv7a'
ARCH='arm'
ANDROIDABI='androideabi'
API=21
else
#64bit
echo "build for 64bit"
ABI='arm64-v8a'
CPU='aarch64'
ARCH='arm64'
ANDROIDABI='android'
API=21
fi

export NDK=/e/Software/NDK/android-ndk-r21e
export PREBUILT=$NDK/toolchains/llvm/prebuilt
export PLATFORM=$NDK/platforms/android-21/arch-$ARCH
export TOOLCHAIN=$PREBUILT/windows-x86_64
export PREFIX=$(pwd)/INSTALL/x264


if [ $archbit -eq 32 ];then
cross_compile_tool=$TOOLCHAIN/bin/arm-linux-androideabi-
echo  $cross_compile_tool
export CC=$TOOLCHAIN/bin/armv7a-linux-$ANDROIDABI$API-clang
#export CXX=$TOOLCHAIN/bin/$CPU-linux-$ANDROIDABI$API-clang++
echo $CC

else
cross_compile_tool=$TOOLCHAIN/bin/aarch64-linux-android-
echo  $cross_compile_tool

export CC=$TOOLCHAIN/bin/aarch64-linux-$ANDROIDABI$API-clang
#export CXX=$TOOLCHAIN/bin/$CPU-linux-$ANDROIDABI$API-clang++
echo $CC
fi



function build_x264(){
./configure \
--prefix=$PREFIX \
--bindir=$PREFIX/bin/$ABI \
--includedir=$PREFIX/include \
--libdir=$PREFIX/libs/$ABI \
--enable-static \
--enable-pic \
--host=$CPU-linux \
--cross-prefix=$cross_compile_tool \
--sysroot=$TOOLCHAIN/sysroot  
  #--extra-cflags="-I$NDK/sysroot/usr/include -I$NDK/sysroot/usr/include/$CPU-linux-$ANDROIDABI" \ 
  #--extra-ldflags="-L$NDK/sysroot/usr/lib/$CPU-linux-$ANDROIDABI -L$PLATFORM/usr/lib"
  
}
cd ../x264
build_x264
make -j15
make install
