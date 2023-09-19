#!/bin/bash -e

__DIR__="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Idea from https://github.com/tdlib/td/issues/77#issuecomment-640719893
cd $__DIR__
./prepare.sh

ABIs="x86 x86_64 armeabi-v7a arm64-v8a"

for abi in $ABIs; do
	# Method 1:
	# - Build ./jniLibs/
	# - Strip the .so files in sub folders and move into ./libs/
	./build_abi.sh $abi
	mkdir -p $__DIR__/libs/$abi
	$__DIR__/strip.sh $__DIR__/build/jni/$abi/td/libtdjson.so $__DIR__/libs/$abi/libtdjson.so

	# Method 2:
	# - Build tdlib
	# - Strip the .so files in sub folders and move into ./libs/
	# ./build_td_abi.sh $abi
	# mkdir -p $__DIR__/libs/$abi
	# $__DIR__/strip.sh $__DIR__/build/td/$abi/libtdjson.so $__DIR__/libs/$abi/libtdjson.so
done
