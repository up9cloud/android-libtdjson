# android-libtdjson

Prebuilt libs for Android

- libs.tar.gz: pure .so files
- jniLibs.tar.gz: .so files with jni

## Usage

TODO

## Example

TODO

## Dev memo

> Build, see .travis.yml also

```console
$ docker run --rm -it -v `pwd`:/app sstc/android-ndk /bin/bash

# ./build.sh
```

> Cleanup .so files to regenerate, for strip testing

```bash
rm -fr ./libs ./jniLibs \
    ./build/arm64-v8a/libtdjson.so \
    ./build/armeabi-v7a/libtdjson.so \
    ./build/x86_64/libtdjson.so \
    ./build-jni/arm64-v8a/libtdjson.so \
    ./build-jni/armeabi-v7a/libtdjson.so \
    ./build-jni/x86_64/libtdjson.so

./build.sh
```

- `.travis.yml`: Travis CI has build time limitation, so can't build on it.
