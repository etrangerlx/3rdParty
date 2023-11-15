#!/bin/sh
# Compiles fftw3 for Android
#NDK 下载地址：https://developer.android.google.cn/ndk/downloads?hl=zh-cn 版本：android-ndk-r19c-linux-x86_64.zip
 
#NDK_DIR="/E/Software/NDK/android-ndk-r14b"
NDK_DIR="/E/Software/NDK/android-ndk-r21e"

SRC_DIR="`pwd`/ffmpeg-4.0.2"
echo $SRC_DIR
INSTALL_DIR="`pwd`/build_install/"
echo $INSTALL_DIR

cd $SRC_DIR
pwd 
# API版本（Android API，NDK版本）
API=21
# arm aarch64 i686 x86_64，所属系统
ARCH=arm
# 编译针对的平台，可以根据自己的需求进行设置
# armv7a aarch64 i686 x86_64
PLATFORM=armv7a
TARGET=$PLATFORM-linux-androideabi
# 工具链的路径，根据编译的平台不同而不同
TOOLCHAIN=$NDK_DIR/toolchains/llvm/prebuilt/windows-x86_64/bin
SYSROOT=$NDK_DIR/sysroot
# 编译文件输出路径
PREFIX=$INSTALL_DIR/$PLATFORM

CFLAG="-D__ANDROID_API__=$API -U_FILE_OFFSET_BITS -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD -Os -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm"

mkdir -p $TMPDIR

build_one()
{
./configure \
--ln_s="cp -rf" \
--prefix=$PREFIX \
--cc=$TOOLCHAIN/$TARGET$API-clang \
--cxx=$TOOLCHAIN/$TARGET$API-clang++ \
--ld=$TOOLCHAIN/$TARGET$API-clang \
--target-os=android \
--arch=$ARCH \
--cpu=$PLATFORM \
--cross-prefix=$TOOLCHAIN/$ARCH-linux-androideabi- \
--disable-asm \
--enable-cross-compile \
--enable-shared \
--enable-static \
--enable-runtime-cpudetect \
--disable-doc \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-doc \
--disable-symver \
--enable-small \
--enable-gpl --enable-nonfree --enable-version3 --disable-iconv \
--enable-jni \
--enable-mediacodec \
--disable-decoders --enable-decoder=vp9 --enable-decoder=h264 --enable-decoder=mpeg4 --enable-decoder=aac \
--disable-encoders --enable-encoder=vp9_vaapi --enable-encoder=h264_nvenc --enable-encoder=h264_v4l2m2m --enable-encoder=hevc_nvenc \
--disable-demuxers --enable-demuxer=rtsp --enable-demuxer=rtp --enable-demuxer=flv --enable-demuxer=h264 \
--disable-muxers --enable-muxer=rtsp --enable-muxer=rtp --enable-muxer=flv --enable-muxer=h264 \
--disable-parsers --enable-parser=mpeg4video --enable-parser=aac --enable-parser=h264 --enable-parser=vp9 \
--disable-protocols --enable-protocol=rtmp --enable-protocol=rtp --enable-protocol=tcp --enable-protocol=udp --enable-protocol=file\
--disable-bsfs \
--disable-indevs --enable-indev=v4l2 \
--disable-outdevs \
--disable-filters \
--disable-postproc \
--extra-cflags="$CFLAG" \
--extra-ldflags="-marm"
}

build_one
make clean
make -j16
make install