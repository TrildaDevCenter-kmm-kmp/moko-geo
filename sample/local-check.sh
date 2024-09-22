#
# Copyright 2023 IceRock MAG Inc. Use of this source code is governed by the Apache 2.0 license.
#

set -e

log() {
  echo "\033[0;32m> $1\033[0m"
}

./gradlew clean assembleDebug
log "sample android success"

if ! command -v xcodebuild &> /dev/null
then
    log "xcodebuild could not be found, skip ios checks"

    ./gradlew build
    log "sample full build success"
else
    ./gradlew clean compileKotlinIosX64
    log "sample ios success"

    ./gradlew clean build syncMultiPlatformLibraryDebugFrameworkIosX64
    log "sample clean build success"

    (
    cd ios-app &&
    pod install &&
    set -o pipefail &&
    xcodebuild -scheme TestProj -workspace TestProj.xcworkspace -configuration Debug -sdk iphonesimulator -arch x86_64 build CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO | xcpretty
    )
    log "sample ios xcode success"
fi
