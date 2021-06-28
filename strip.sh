#!/bin/bash -e

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -z "$ANDROID_SDK_ROOT" ]; then
	>&2 echo "ANDROID_SDK_ROOT not set"
	exit 2
fi
NDK_VERSION=22.1.7171670
export ANDROID_NDK_HOME="$ANDROID_SDK_ROOT/ndk/$NDK_VERSION"

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

strip_options="--strip-sections --strip-unneeded"
$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$HOST_TAG/bin/llvm-strip $strip_options "$from" -o "$to"
