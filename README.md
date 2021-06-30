# android-libtdjson

[![Releases](https://github.com/up9cloud/android-libtdjson/actions/workflows/main.yml/badge.svg)](https://github.com/up9cloud/android-libtdjson/actions/workflows/main.yml)

Prebuilt libs for Android

> Releases

- libs.tar.gz: pure .so files
- jniLibs.tar.gz: .so files with jni

## Usage

TODO

## Example

TODO

## Dev memo

> Build on local, see `.github/workflows/main.yml` also

```console
$ docker run --rm -it -v `pwd`:/app sstc/android-ndk /bin/bash

# ./build.sh
```

> Cleanup generated .so files for strip testing

```bash
rm -fr \
    ./build/jni/**/*.so \
    ./build/jni/**/td/*.so \
    ./build/td/**/*.so \
    ./jniLibs \
    ./libs

./build.sh
```

- `.travis.yml`: Travis CI has build time limitation (1 hour), and building this lib needs much more than it, so can't build on it.
