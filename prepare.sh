#!/bin/bash -e

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

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

mkdir -p $__DIR__/build
cd $__DIR__/build
# Need to generate some files first, see https://github.com/tdlib/td/issues/1077#issuecomment-640056388
if [ ! -d "prepare_cross_compiling" ]; then
	mkdir -p prepare_cross_compiling
	cd prepare_cross_compiling
	cmake ../../td || exit 1
	cmake --build . --target prepare_cross_compiling || exit 1
	cd ..
fi
