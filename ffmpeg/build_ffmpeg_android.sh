#!/usr/bin/env bash

NDK_HOME=/e/Software/NDK/android-ndk-r21e
PREFIX=$(pwd)/INSTALL/ffmpeg
X264_PREFIX=$(pwd)/INSTALL/x264
HOST_PLATFORM=windows-x86_64
TOOLCHAINS="$NDK_HOME/toolchains/llvm/prebuilt/$HOST_PLATFORM"
API=21
PLATFORM=android-$API
PLATFORM_64=android-$API

CONFIG_LOG_PATH=${PREFIX}/log
COMMON_OPTIONS=
CONFIGURATION=

cd ffmpeg-4.0.2

echo $TMPDIR
build(){
    APP_ABI=$1
    echo "======== > Start build $APP_ABI"
    case ${APP_ABI} in
    # armeabi )
    #     ARCH="arm"
    #     CPU="armv6"
    #     MARCH="armv6"
    #     TOOLCHAINS="$NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/$HOST_PLATFORM"
    #     CROSS_PREFIX="$TOOLCHAINS/bin/arm-linux-androideabi-"
    #     SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-arm"
    #     EXTRA_CFLAGS="-march=$MARCH"
    #     EXTRA_CFLAGS="$EXTRA_CFLAGS -mfloat-abi=softfp -mfpu=vfp"
    #     EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK_HOME/sysroot/usr/include/arm-linux-androideabi"
    #     EXTRA_CFLAGS="$EXTRA_CFLAGS -isysroot $NDK_HOME/sysroot"
    #     EXTRA_LDFLAGS="-lc -lm -ldl -llog"
    #     EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib"
    #     EXTRA_OPTIONS="--disable-x86asm"
    # ;;
    armeabi-v7a )
        ARCH="arm"
        CPU="armv7-a"
        MARCH="armv7-a"
        
        CROSS_PREFIX="$TOOLCHAINS/bin/arm-linux-androideabi-"
		CC="$TOOLCHAINS/bin/armv7a-linux-androideabi$API-clang"
        CXX="$TOOLCHAINS/bin/armv7a-linux-androideabi$API-clang++"
        SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-arm"
        EXTRA_CFLAGS="-march=$MARCH"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -mfloat-abi=softfp -mfpu=vfpv3-d16"
        EXTRA_CFLAGS="$EXTRA_CFLAGS  -I$X264_PREFIX/include  -I$NDK_HOME/sysroot/usr/include -I$NDK_HOME/sysroot/usr/include/arm-linux-androideabi"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -isysroot $NDK_HOME/sysroot"
        EXTRA_LDFLAGS="-lc -lm -ldl -llog"
        #EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,--fix-cortex-a8"
        #EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib"
		EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib -L$X264_PREFIX/libs/$APP_ABI"
        #EXTRA_OPTIONS="--enable-neon --disable-x86asm"
    ;;
    arm64-v8a )
        ARCH="aarch64"
        CPU="armv8-a"
        MARCH="armv8-a"
        CROSS_PREFIX="$TOOLCHAINS/bin/aarch64-linux-android-"
        CC="$TOOLCHAINS/bin/aarch64-linux-android$API-clang"
        CXX="$TOOLCHAINS/bin/aarch64-linux-android$API-clang++"
        SYSROOT="$NDK_HOME/platforms/$PLATFORM_64/arch-arm64"
        EXTRA_CFLAGS="-march=$MARCH"
		EXTRA_CFLAGS="$EXTRA_CFLAGS -mfloat-abi=softfp -mfpu=neon"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -I$X264_PREFIX/include -I$NDK_HOME/sysroot/usr/include -I$NDK_HOME/sysroot/usr/include/aarch64-linux-android"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -isysroot $NDK_HOME/sysroot"
        EXTRA_LDFLAGS="-lc -lm -ldl -llog"
        EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib -L$X264_PREFIX/libs/$APP_ABI"
        #EXTRA_OPTIONS="--enable-neon --enable-asm"
    ;;
    # x86 )
    #     ARCH="x86"
    #     CPU="i686"
    #     MARCH="i686"
    #     TOOLCHAINS="$NDK_HOME/toolchains/x86-4.9/prebuilt/$HOST_PLATFORM"
    #     CROSS_PREFIX="$TOOLCHAINS/bin/i686-linux-android-"
    #     SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-x86"
    #     EXTRA_CFLAGS="-march=$MARCH"
    #     EXTRA_CFLAGS="$EXTRA_CFLAGS -mtune=intel -mssse3 -mfpmath=sse -m32"
    #     EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK_HOME/sysroot/usr/include/i686-linux-android"
    #     EXTRA_CFLAGS="$EXTRA_CFLAGS -isysroot $NDK_HOME/sysroot"
    #     EXTRA_LDFLAGS="-lc -lm -ldl -llog"
    #     EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib"
    #     EXTRA_OPTIONS="--disable-asm"
    # ;;
    # x86_64 )
    #     ARCH="x86_64"
    #     CPU="x86_64"
    #     MARCH="x86-64"
    #     TOOLCHAINS="$NDK_HOME/toolchains/x86_64-4.9/prebuilt/$HOST_PLATFORM"
    #     CROSS_PREFIX="$TOOLCHAINS/bin/x86_64-linux-android-"
    #     SYSROOT="$NDK_HOME/platforms/$PLATFORM_64/arch-x86_64"
    #     EXTRA_CFLAGS="-march=$MARCH"
    #     EXTRA_CFLAGS="$EXTRA_CFLAGS -mtune=intel -msse4.2 -mpopcnt -m64"
    #     EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK_HOME/sysroot/usr/include/x86_64-linux-android"
    #     EXTRA_CFLAGS="$EXTRA_CFLAGS -isysroot $NDK_HOME/sysroot"
    #     EXTRA_LDFLAGS="-lc -lm -ldl -llog"
    #     EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib64 -L$SYSROOT/usr/lib64"
    #     EXTRA_OPTIONS="--disable-asm"
    # ;;
    esac

    echo "-------- > Start clean workspace"
    make clean

    echo "-------- > Start build configuration"
    CONFIGURATION="$COMMON_OPTIONS"
    CONFIGURATION="$CONFIGURATION --logfile=$CONFIG_LOG_PATH/config_$APP_ABI.log"
    CONFIGURATION="$CONFIGURATION --prefix=$PREFIX"
    CONFIGURATION="$CONFIGURATION --libdir=$PREFIX/libs/$APP_ABI"
    CONFIGURATION="$CONFIGURATION --incdir=$PREFIX/include"
    CONFIGURATION="$CONFIGURATION --pkgconfigdir=$PREFIX/pkgconfig/$APP_ABI"
    CONFIGURATION="$CONFIGURATION --arch=$ARCH"
    CONFIGURATION="$CONFIGURATION --cpu=$CPU"
    CONFIGURATION="$CONFIGURATION --cc=$CC"
    CONFIGURATION="$CONFIGURATION --cxx=$CXX"
    CONFIGURATION="$CONFIGURATION --cross-prefix=$CROSS_PREFIX"
    CONFIGURATION="$CONFIGURATION --sysroot=$TOOLCHAINS/sysroot"
    CONFIGURATION="$CONFIGURATION --extra-ldexeflags=-pie"
    CONFIGURATION="$CONFIGURATION $EXTRA_OPTIONS"

    echo "-------- > Start config makefile with $CONFIGURATION --extra-cflags="${EXTRA_CFLAGS}" --extra-ldflags="${EXTRA_LDFLAGS}""
    ./configure ${CONFIGURATION} \
        --extra-cflags="$EXTRA_CFLAGS -D__ANDROID_API__=21" \
        --extra-ldflags="$EXTRA_LDFLAGS"

    echo "-------- > Start make $APP_ABI with -j8"
    make -j15

    echo "-------- > Start install $APP_ABI"
    make install
    echo "++++++++ > make and install $APP_ABI complete."

}

build_all(){

    COMMON_OPTIONS="$COMMON_OPTIONS --target-os=android"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-static"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-shared"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-protocols"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-cross-compile"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-optimizations"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-debug"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-small"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-doc"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-indev=v4l2"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-programs"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffmpeg"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffplay"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffprobe"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-symver"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-hwaccels"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-network"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-pthreads"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-mediacodec"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-jni"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-zlib"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-pic"
    COMMON_OPTIONS="$COMMON_OPTIONS  --enable-libx264"
    COMMON_OPTIONS="$COMMON_OPTIONS  --enable-gpl --enable-nonfree --enable-version3 --disable-iconv "
    #COMMON_OPTIONS="$COMMON_OPTIONS --enable-avresample"
    #COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=h264"
    #COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=mpeg4"
    #COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=mjpeg"
    #COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=png"
    #COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=vorbis"
    #COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=opus"
    #COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=flac"

    echo "COMMON_OPTIONS=$COMMON_OPTIONS"
    echo "PREFIX=$PREFIX"
    echo "CONFIG_LOG_PATH=$CONFIG_LOG_PATH"

    mkdir -p ${CONFIG_LOG_PATH}

#    build $app_abi
     #build "armeabi"
     build "armeabi-v7a"
     #build "arm64-v8a"
     #build "x86"
     #build "x86_64"
}

echo "-------- Start --------"

build_all

echo "-------- End --------"
