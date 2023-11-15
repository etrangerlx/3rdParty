#!/bin/sh
# Compiles fftw3 for Android
#NDK 下载地址：https://developer.android.google.cn/ndk/downloads?hl=zh-cn 版本：android-ndk-r19c-linux-x86_64.zip
 
NDK_DIR="/E/Software/NDK/android-ndk-r14b"

SRC_DIR="`pwd`/fftw-3.3.10"
echo $SRC_DIR
INSTALL_DIR="`pwd`/build_install/Android/arm8"
echo $INSTALL_DIR

cd $SRC_DIR
pwd 
export API=21
export MARCH=arm64 #arm、x86、x86_64
export TOOLCHAIN="$NDK_DIR/toolchains/aarch64-linux-android-4.9/prebuilt/windows-x86_64/bin"
export PATH="$TOOLCHAIN:$PATH"
export SYS_ROOT="$NDK_DIR/platforms/android-$API/arch-$MARCH/"
export CC="aarch64-linux-android-gcc --sysroot=$SYS_ROOT"
echo $CC
export LD="aarch64-linux-android-ld"
export AR="aarch64-linux-android-ar"
export RANLIB="aarch64-linux-android-ranlib"
export STRIP="aarch64-linux-android-strip"
export LD_LIBRARY_PATH="$NDK_DIR/toolchains/aarch64-linux-android-4.9/prebuilt/windows-x86_64/lib/gcc/aarch64-linux-android/4.9.x"

#export CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon -fno-builtin-memmove -mthumb -D__ANDROID_API__=$API" 
export C_INCLUDE_PATH="$NDK_DIR/sysroot/usr/include:$NDK_DIR/sysroot/usr/include/aarch64-linux-android"
 
mkdir -p $INSTALL_DIR
./configure --host=aarch64-linux-android \
            --prefix=$INSTALL_DIR \
			LDFLAGS=" -L$LD_LIBRARY_PATH -L$SYS_ROOT/usr/lib " \
			CFLAGS="-march=armv8-a -D__ANDROID_API__=$API"  \
            LIBS=" -lc -lgcc " \
            --enable-shared \
            --enable-float --enable-neon
 
 
make -j16
make install