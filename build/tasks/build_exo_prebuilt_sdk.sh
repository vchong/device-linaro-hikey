#!/bin/bash

export ANDROID_HOME=$PWD/../wv/prebuilts/sdk
mkdir -p ~/.android/
echo "count=0" > ~/.android/repositories.cfg

if [ ! -d "ExoPlayer" ]; then
	git clone https://github.com/google/ExoPlayer --depth 1
fi

cd ExoPlayer
./gradlew assembleDebug
cp ./demos/main/buildout/outputs/apk/withExtensions/debug/demo-withExtensions-debug.apk ../../wv/out/target/product/hikey/data/app/
cd -
