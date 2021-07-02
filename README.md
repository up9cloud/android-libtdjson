# android-libtdjson

[![Releases](https://github.com/up9cloud/android-libtdjson/actions/workflows/main.yml/badge.svg)](https://github.com/up9cloud/android-libtdjson/actions/workflows/main.yml)

Prebuilt [libtdjson](https://github.com/tdlib/td) for Android

> Releases

- libs.tar.gz: .so files without jni
- jniLibs.tar.gz: .so files with jni

> Packages

- maven

## Installation

> Method 1: Download jniLibs

- Download jniLibs.tar.gz (from `Releases`) and extract it to your ./app/`src/main/jniLibs/`
- Copy `./app/src/main/java/io/github/up9cloud/td/JsonClient.java` to your repo

> TODO: Method 2: Download .jar

- Download .jar file (from `Packages`) to your ./app/`libs/`
- Be sure "*.jar" is the part of dependencies in your `build.gradle` file

    ```gradle
    dependencies {
        implementation fileTree(dir: "libs", include: ["*.jar"])
    }
    ```

> Method 3: Github Maven

- Add those to your `build.gradle` file

    ```gradle
    repositories {
        google()
        ...
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/up9cloud/android-libtdjson")
            credentials {
                username = System.getenv("GITHUB_ACTOR")
                password = System.getenv("GITHUB_TOKEN")
            }
        }
    }
    dependencies {
        // modify the version, e.q. 1.7.0
        implementation 'io.github.up9cloud:td:<version>'
    }
    ```

- Setup ENVs

    ```bash
    export GITHUB_ACTOR=<your github account>
    export GITHUB_TOKEN=<your github personal access token>
    ```

Other refs:

- GitHub Docs - [Gradle registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-gradle-registry#installing-a-package)
- [enefce/AndroidLibraryForGitHubPackagesDemo](https://github.com/enefce/AndroidLibraryForGitHubPackagesDemo)

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
