#!/bin/bash -e

__DIR__="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

if [ ! -d "td" ]; then
	cd $__DIR__
	git clone https://github.com/tdlib/td.git
	cd td
	# How to get the hash if there is no version tag:
	# - Goto https://github.com/tdlib/td/blame/master/CMakeLists.txt
	# - Check the version from the line: `project(TDLib VERSION <version>...`
	# - Copy version and paste to:
	# git checkout tags/v1.8.23
	# - Click the commit link
	# - Copy and paste the commit hash from the browser url link, e.q. https://github.com/tdlib/td/commit/...
	git checkout 27c3eaeb4964bd5f18d8488e354abde1a4383e49
	cd ..
fi

if [ ! -d "openssl" ]; then
	cd $__DIR__
	git clone https://github.com/PurpleI2P/OpenSSL-for-Android-Prebuilt.git
	mv OpenSSL-for-Android-Prebuilt/openssl-1.1.1k-clang openssl
	rm -fr OpenSSL-for-Android-Prebuilt
fi

# Need to generate some files first, see https://github.com/tdlib/td/issues/1077#issuecomment-640056388
if [ ! -d "$__DIR__/build/td/prepare_cross_compiling" ]; then
	mkdir -p $__DIR__/build/td/prepare_cross_compiling
	cd $__DIR__/build/td/prepare_cross_compiling

	cmake $__DIR__/td || exit 1
	cmake --build . --target prepare_cross_compiling || exit 1
fi
