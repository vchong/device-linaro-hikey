#!/bin/bash

#SDK_FILE=tools_r25.2.5-linux.zip
SDK_FILE=sdk-tools-linux-4333796.zip

if [ ! -d "tools" ]; then
	# do NOT rename 'tools' after unzip else update WILL FAIL!
	# if you must rename then symlink it to 'tools'

	if [ ! -e ${SDK_FILE} ]; then
		wget https://dl.google.com/android/repository/${SDK_FILE}
	fi

	unzip ${SDK_FILE}
	#(while :; do echo 'y'; sleep 2; done) | tools/android update sdk --no-ui
	(while :; do echo 'y'; sleep 2; done) | tools/bin/sdkmanager --update

	mkdir -p ~/.android/

	# install the necessary build tools
	#tools/android list sdk --all
	#tools/android update sdk -u -a -t 47
fi

export ANDROID_HOME=$PWD
echo "count=0" > ~/.android/repositories.cfg

if [ ! -d "ExoPlayer" ]; then
	git clone https://github.com/google/ExoPlayer --depth 1
fi

cd ExoPlayer
./gradlew assembleDebug
cp ./demos/main/buildout/outputs/apk/withExtensions/debug/demo-withExtensions-debug.apk ../../wv/out/target/product/hikey/data/app/
cd -
