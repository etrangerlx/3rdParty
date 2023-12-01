#! /bin/bash
archbit=64
if [ $archbit -eq 32 ];then
echo "build for 32bit"
#32bit
ABI='armeabi-v7a'
CPU='armv7a'
ARCH='arm'
ANDROIDABI='androideabi'
API=24
host=arm-linux
else
#64bit
echo "build for 64bit"
ABI='arm64-v8a'
CPU='aarch64'
ARCH='arm64'
ANDROIDABI='android'
API=24
host=arm-linux
fi

export NDK=/e/Software/NDK/android-ndk-r21e
export PREBUILT=$NDK/toolchains/llvm/prebuilt
export PLATFORM=$NDK/platforms/android-21/arch-$ARCH
export TOOLCHAIN=$PREBUILT/windows-x86_64
export PREFIX=$(pwd)/INSTALL/fdk-aac
echo $PREFIX

export PATH=$PATH:$TOOLCHAIN/bin/
echo $PATH

cd fdk-aac-2.0.2

if [ $archbit -eq 32 ];then

cross_compile_tool=arm-linux-androideabi
echo  $cross_compile_tool
export CC=$TOOLCHAIN/bin/armv7a-linux-$ANDROIDABI$API-clang
export CXX=$TOOLCHAIN/bin/armv7a-linux-$ANDROIDABI$API-clang++
export STRIP=$TOOLCHAIN/bin/arm-linux-$ANDROIDABI-strip
export LDFLAGS="-L$NDK/sysroot/usr/lib/arm-linux-$ANDROIDABI -L$PLATFORM/usr/lib"
export CPPFLAGS="-I$NDK_HOME/sysroot/usr/include -I$NDK_HOME/sysroot/usr/include/arm-linux-android"
echo $CC

else

cross_compile_tool=aarch64-linux-android
echo  $cross_compile_tool
export CC=$TOOLCHAIN/bin/aarch64-linux-$ANDROIDABI$API-clang
export CXX=$TOOLCHAIN/bin/aarch64-linux-$ANDROIDABI$API-clang++
export STRIP=$TOOLCHAIN/bin/aarch64-linux-$ANDROIDABI-strip
export LDFLAGS="-L$NDK/sysroot/usr/lib/aarch64-linux-$ANDROIDABI -L$PLATFORM/usr/lib"
export CPPFLAGS="-I$NDK_HOME/sysroot/usr/include -I$NDK_HOME/sysroot/usr/include/aarch64-linux-android"
echo $CC
fi


./autogen.sh
function build_one() {
./configure \
--enable-static \
--enable-shared \
--enable-example \
--prefix=$PREFIX \
--bindir=$PREFIX/bin/$ABI \
--libdir=$PREFIX/$ABI \
--includedir=$PREFIX/include \
--with-sysroot=$TOOLCHAIN/bin/sysroot \
--host=$cross_compile_tool
}
build_one
#make clean
#make -j15
#make install
