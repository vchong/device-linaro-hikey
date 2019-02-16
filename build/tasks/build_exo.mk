ifneq ($(filter hikey%, $(TARGET_DEVICE)),)

.PHONY: wv
wv:
	if [ -d "external/optee-widevine-ref" ]; then \
		echo "##################"; \
		echo "Building ExoPlayer"; \
		echo "##################"; \
		if [ ! -d "../ExoPlayer" ]; then \
			git clone https://github.com/google/ExoPlayer --depth 1 ../ExoPlayer; \
			cd ../ExoPlayer; \
			echo "buildScan { licenseAgreementUrl = 'https://gradle.com/terms-of-service'; licenseAgree = 'yes' }" >> build.gradle; \
			cd -; \
		fi; \
	fi
	cp -r external/optee-widevine-ref/licenses prebuilts/sdk/
	#export ANDROID_HOME=$(PWD)/prebuilts/sdk &&
	export ANDROID_HOME=$(PWD)/../sdk && \
		echo "ANDROID_HOME=$$ANDROID_HOME" && \
		cd ../ExoPlayer && \
		echo "sdk.dir=$$ANDROID_HOME" > local.properties && \
		./gradlew --scan assembleDebug

droidcore: wv

endif
