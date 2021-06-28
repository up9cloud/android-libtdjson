#!/bin/bash -e

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -z "$ANDROID_SDK_ROOT" ]; then
	>&2 echo "ANDROID_SDK_ROOT not set"
	exit 2
fi
NDK_VERSION=22.1.7171670
export ANDROID_NDK_HOME="$ANDROID_SDK_ROOT/ndk/$NDK_VERSION"

./prepare.sh

# Idea from https://github.com/tdlib/td/issues/77#issuecomment-640719893
# ABIs="x86 x86_64 armeabi-v7a arm64-v8a"
ABIs="x86_64 armeabi-v7a arm64-v8a"
# x86 would cause error:
# ld: error: undefined symbol: __memcpy_chk
# >>> referenced by string.h:48 (bionic/libc/include/bits/fortify/string.h:48)
# >>>               crc_folding.o:(crc_fold_copy) in archive /opt/android-sdk-linux/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/i686-linux-android/libz.a
# clang++: error: linker command failed with exit code 1 (use -v to see invocation)
# make[2]: *** [CMakeFiles/tdjson.dir/build.make:125: libtdjson.so] Error 1
# make[1]: *** [CMakeFiles/Makefile2:408: CMakeFiles/tdjson.dir/all] Error 2
# make: *** [Makefile:146: all] Error 2
for abi in $ABIs; do
	./build_jni_lib.sh $abi
	./build_lib.sh $abi
done
