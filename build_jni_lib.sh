#!/bin/bash -e

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -z "$ANDROID_SDK_ROOT" ]; then
	>&2 echo "ANDROID_SDK_ROOT not set"
	exit 2
fi
NDK_VERSION=22.1.7171670
export ANDROID_NDK_HOME="$ANDROID_SDK_ROOT/ndk/$NDK_VERSION"

cmd_cmake="$__DIR__/cmake/bin/cmake"
abi=$1

cd $__DIR__

mkdir -p ./build-jni/$abi
cd $__DIR__/build-jni/$abi
$cmd_cmake $__DIR__/app/src/main/cpp -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DANDROID_ABI=${abi} || exit 1
$cmd_cmake --build . || exit 1
