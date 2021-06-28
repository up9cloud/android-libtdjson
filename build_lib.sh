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

mkdir -p ./build/$abi
cd $__DIR__/build/$abi
OPENSSL_ROOT_DIR="$__DIR__/openssl"
OPENSSL_CRYPTO_LIBRARY="$OPENSSL_ROOT_DIR/$abi/lib/libcrypto.a"
OPENSSL_SSL_LIBRARY="$OPENSSL_ROOT_DIR/$abi/lib/libssl.a"
$cmd_cmake $__DIR__/td -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DANDROID_ABI=${abi} \
	-DOPENSSL_FOUND=1 \
	-DOPENSSL_INCLUDE_DIR="$OPENSSL_ROOT_DIR/include" \
	-DOPENSSL_CRYPTO_LIBRARY="$OPENSSL_CRYPTO_LIBRARY" \
	-DOPENSSL_SSL_LIBRARY="$OPENSSL_SSL_LIBRARY" \
	-DOPENSSL_LIBRARIES="$OPENSSL_SSL_LIBRARY;$OPENSSL_CRYPTO_LIBRARY" \
	|| exit 1
$cmd_cmake --build . || exit 1
$__DIR__/strip.sh $__DIR__/build/$abi/libtdjson.so $__DIR__/libs/$abi/libtdjson.so
