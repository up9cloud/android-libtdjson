#!/bin/bash -e

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Idea from https://github.com/tdlib/td/issues/77#issuecomment-640719893
cd $__DIR__
./prepare.sh

# ABIs="x86 x86_64 armeabi-v7a arm64-v8a"
ABIs="x86_64 armeabi-v7a arm64-v8a"
# FIXME: x86 would cause error:
# ld: error: undefined symbol: __memcpy_chk
# >>> referenced by string.h:48 (bionic/libc/include/bits/fortify/string.h:48)
# >>>               crc_folding.o:(crc_fold_copy) in archive /opt/android-sdk-linux/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/i686-linux-android/libz.a
# clang++: error: linker command failed with exit code 1 (use -v to see invocation)
# make[2]: *** [CMakeFiles/tdjson.dir/build.make:125: libtdjson.so] Error 1
# make[1]: *** [CMakeFiles/Makefile2:408: CMakeFiles/tdjson.dir/all] Error 2
# make: *** [Makefile:146: all] Error 2

for abi in $ABIs; do
	# Build both ./jniLibs/ and ./libs/
	./build_abi.sh $abi

	# Build td and strip .so to ./libs/
	# ./build_td_abi.sh $abi
	# mkdir -p $__DIR__/libs/$abi
	# $__DIR__/strip.sh $__DIR__/build/$abi/libtdjson.so $__DIR__/libs/$abi/libtdjson.so
done
