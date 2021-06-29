#!/bin/bash -e

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -z "$ANDROID_NDK_HOME" ]; then
	>&2 echo "ANDROID_NDK_HOME not set"
	exit 2
fi

abi=$1

mkdir -p $__DIR__/build/$abi
cd $__DIR__/build/$abi
OPENSSL_ROOT_DIR="$__DIR__/openssl"
OPENSSL_CRYPTO_LIBRARY="$OPENSSL_ROOT_DIR/$abi/lib/libcrypto.a"
OPENSSL_SSL_LIBRARY="$OPENSSL_ROOT_DIR/$abi/lib/libssl.a"
cmake $__DIR__/td -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DANDROID_ABI=${abi} \
	-DOPENSSL_FOUND=1 \
	-DOPENSSL_INCLUDE_DIR="$OPENSSL_ROOT_DIR/include" \
	-DOPENSSL_CRYPTO_LIBRARY="$OPENSSL_CRYPTO_LIBRARY" \
	-DOPENSSL_SSL_LIBRARY="$OPENSSL_SSL_LIBRARY" \
	-DOPENSSL_LIBRARIES="$OPENSSL_SSL_LIBRARY;$OPENSSL_CRYPTO_LIBRARY" \
	|| exit 1
cmake --build . || exit 1
