#!/bin/bash -e

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -z "$ANDROID_SDK_ROOT" ]; then
	>&2 echo "ANDROID_SDK_ROOT not set"
	exit 2
fi
NDK_VERSION=22.1.7171670
export ANDROID_NDK_HOME="$ANDROID_SDK_ROOT/ndk/$NDK_VERSION"

apt install --no-install-recommends -y libssl-dev zlib1g-dev gperf build-essential

cd $__DIR__

if [ ! -d "td" ]; then
	git clone https://github.com/tdlib/td.git
	cd td
	git checkout tags/v1.7.0
	cd ..
fi

if [ ! -d "openssl" ]; then
	git clone https://github.com/PurpleI2P/OpenSSL-for-Android-Prebuilt.git
	mv OpenSSL-for-Android-Prebuilt/openssl-1.1.1k-clang openssl
	rm -fr OpenSSL-for-Android-Prebuilt
fi

cmd_cmake="$__DIR__/cmake/bin/cmake"
if [ ! -f "$cmd_cmake" ]; then
	CMAKE_VERSION=3.20.5
	apt install --no-install-recommends -y wget
	wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz -O cmake.tar.gz
	tar -xf cmake.tar.gz
	mv cmake-${CMAKE_VERSION}-linux-x86_64 cmake
	rm cmake.tar.gz
fi

cd $__DIR__
mkdir -p build
cd build
# Need to generate some files first, see https://github.com/tdlib/td/issues/1077#issuecomment-640056388
if [ ! -d "prepare_cross_compiling" ]; then
	mkdir -p prepare_cross_compiling
	cd prepare_cross_compiling
	$cmd_cmake ../../td || exit 1
	$cmd_cmake --build . --target prepare_cross_compiling || exit 1
	cd ..
fi
