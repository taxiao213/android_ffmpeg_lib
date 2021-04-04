#!/bin/bash

# ndk路径
NDK=/home/build/workspace/hqq/vision/vision-app/ndk/android-ndk-r21b
# 编译工具链目录，ndk17版本以上用的是clang，以下是gcc
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
# 版本号
API=21
# 交叉编译树的根目录(查找相应头文件和库用)
SYSROOT="${TOOLCHAIN}/sysroot"
# 定义执行configure的shell方法
function build_android() {
    ./configure \
        --prefix=$PREFIX \
        --enable-shared \
        --disable-static \
        --enable-jni \
        --enable-gpl \
        --enable-small \
        --disable-doc \
        --disable-programs \
        --disable-symver \
        --target-os=android \
        --arch=$ARCH \
        --cpu=$CPU \
        --cc=$CC \
        --cxx=$CXX \
        --enable-cross-compile \
 	--cross-prefix=$CROSS_COMPILE \
 	--sysroot=$SYSROOT \
        --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
        --extra-ldflags="" \
        --disable-asm \
        $COMMON_FF_CFG_FLAGS
    make clean
    make -j16
    make install
}


# arm
OUTPUT_FOLDER=arm
ARCH=arm
CPU=armv7-a
TOOL_CPU_NAME=armv7a
TOOL_PREFIX=$TOOLCHAIN/bin/${TOOL_CPU_NAME}-linux-androideabi
OPTIMIZE_CFLAGS="-marm -march=$CPU"
PREFIX=${PWD}/android/$OUTPUT_FOLDER
CROSS_COMPILE=$TOOLCHAIN/bin/arm-linux-androideabi-
CC=${TOOL_PREFIX}${API}-clang
CXX=${TOOL_PREFIX}${API}-clang++
build_android

# arm64，这个指令集最低支持api21
OUTPUT_FOLDER=arm64-v8a
ARCH=aarch64
CPU=armv8-a
TOOL_CPU_NAME=aarch64
TOOL_PREFIX=$TOOLCHAIN/bin/${TOOL_CPU_NAME}-linux-android
OPTIMIZE_CFLAGS="-march=$CPU"
PREFIX=${PWD}/android/$OUTPUT_FOLDER
CROSS_COMPILE=$TOOLCHAIN/bin/aarch64-linux-android-
CC=${TOOL_PREFIX}${API}-clang
CXX=${TOOL_PREFIX}${API}-clang++
build_android

# x86
OUTPUT_FOLDER=x86
ARCH=x86
CPU=x86
TOOL_CPU_NAME=i686
TOOL_PREFIX=$TOOLCHAIN/bin/${TOOL_CPU_NAME}-linux-android
OPTIMIZE_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
PREFIX=${PWD}/android/$OUTPUT_FOLDER
CROSS_COMPILE=$TOOLCHAIN/bin/i686-linux-android-
CC=${TOOL_PREFIX}${API}-clang
CXX=${TOOL_PREFIX}${API}-clang++
build_android

# x86_64，这个指令集最低支持api21
OUTPUT_FOLDER=x86_64
ARCH=x86_64
CPU=x86-64
TOOL_CPU_NAME=x86_64
TOOL_PREFIX=$TOOLCHAIN/bin/${TOOL_CPU_NAME}-linux-android
OPTIMIZE_CFLAGS="-march=$CPU -mtune=intel -msse4.2 -mpopcnt -m64"
# 输出目录
PREFIX=${PWD}/android/$OUTPUT_FOLDER
CROSS_COMPILE=$TOOLCHAIN/bin/x86_64-linux-android-
# so的输出目录， --libdir=$LIB_DIR 可以不用指定，默认会生成在$PREFIX/lib目录中
#LIB_DIR="${PWD}/android/libs/$OUTPUT_FOLDER"
# 编译器
CC=${TOOL_PREFIX}${API}-clang
CXX=${TOOL_PREFIX}${API}-clang++
build_android

