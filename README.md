# android-libtdjson

[![Releases](https://github.com/up9cloud/android-libtdjson/actions/workflows/main.yml/badge.svg)](https://github.com/up9cloud/android-libtdjson/actions/workflows/main.yml)

Prebuilt [libtdjson](https://github.com/tdlib/td) for Android

> Version

- Git tag is same as the version of tdlib

> Releases

- libs.tar.gz: .so files without jni
- jniLibs.tar.gz: .so files with jni

> Packages

- maven

> Supported architectures

| Platform         | Architecture |     |
| ---------------- | ------------ | --- |
| Android          | armeabi-v7a  | ✅   |
|                  | arm64-v8a    | ✅   |
| Android emulator | x86          | ✅   |
|                  | x86_64       | ✅   |

## Installation

> Method 1: Download jniLibs

- Download `jniLibs.tar.gz` (from `Releases`) and extract it to your ./app/`src/main/jniLibs/`
- Download `./app/src/main/java/io/github/up9cloud/td/JsonClient.java` and put to your code base.

> Method 2: Github Maven

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
    // Modify the version, see release
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

## Dev memo

- Bump the version of tdlib
  - Modify the version for git checkout in `./prepare.sh`
  - Modify the getVersionName function in `./app/build.gradle`
  - Git commit (message example: `bump td to vx.x.x`)
  - Git add tag (`git tag vx.x.x`, the tag version should be same as the version of tdlib)
  - Push with tags (`git push && git push --tags`)
  - Wait for CI task
- Build on local, see `.github/workflows/main.yml` also

  ```bash
  # cleanup generated .so files for strip testing
  rm -fr \
    ./build/jni/**/*.so \
    ./build/jni/**/td/*.so \
    ./build/td/**/*.so \
    ./jniLibs \
    ./libs

  docker run --rm -v $(pwd):/app sstc/android-ndk ./build.sh
  ```

- update gradle

  ```bash
  docker run --rm -v $(pwd):/app sstc/android-ndk ./gradlew wrapper --gradle-version latest
  ```

- manually publish maven to github

  ```bash
  # The GITHUB_TOKEN must have `write:packages` permission
  docker run --rm -v $(pwd):/app -e GITHUB_TOKEN=${GITHUB_TOKEN} sstc/android-ndk ./gradlew assembleRelease publish
  ```

- `.travis.yml`: Travis CI has build time limitation (1 hour), and building this lib needs much more than it, so can't build on it.

## License

MIT

- TDLib license, see [td](https://github.com/tdlib/td)
