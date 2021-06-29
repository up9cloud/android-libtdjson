#!/bin/bash -e

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -z "$ANDROID_NDK_HOME" ]; then
	>&2 echo "ANDROID_NDK_HOME not set"
	exit 2
fi

if [ -z "$1" ]; then
	exit 2
fi
from=$1
to=$2

# https://developer.android.com/ndk/guides/other_build_systems#overview
case `uname -s` in
	Darwin)
		HOST_TAG=darwin-x86_64
	;;
	Windows)
		if [ `uname -m` = "x86_64" ]; then
			HOST_TAG=windows-x86_64
		else
			HOST_TAG=windows
		fi
	;;
	Linux|*)
		HOST_TAG=linux-x86_64
	;;
esac

# Should same as ./app/src/main/cpp/CMakeLists.txt
# FIXME: DO NOT use option "--strip-sections", it will cause error:
# E/linker  ( 8837): "/data/app/~~DmkN-Giykw7LVUfrR5b7fg==/org.naji.td.tdlib.tdlib_example-YJzag0gDC1cnMn_ML_iILQ==/lib/x86_64/libtdjson.so" has unsupported e_shentsize: 0x0 (expected 0x40)
strip_options="--strip-debug --strip-unneeded"
$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$HOST_TAG/bin/llvm-strip $strip_options "$from" -o "$to"
