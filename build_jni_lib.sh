#!/bin/bash -e

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -z "$ANDROID_NDK_HOME" ]; then
	>&2 echo "ANDROID_NDK_HOME not set"
	exit 2
fi

abi=$1

mkdir -p $__DIR__/build-jni/$abi
cd $__DIR__/build-jni/$abi
cmake $__DIR__/app/src/main/cpp -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DANDROID_ABI=${abi} || exit 1
cmake --build . || exit 1
