APP = ../app/FacebookRenshu.app
IPA = $(PWD)/FacebookRenshu.ipa
TESTFLIGHT_RESULT = testflight_result.json

DEVELOPER_NAME = iPhone Developer: Toru Hisai (2LA63FS7DX)
PROVISIONING_PROFILE = wildercard.mobileprovision

API_TOKEN = deea6b8d4f2adb2bb2512e27c8580613_MTM1ODk0MjAxMS0wOC0yMSAwMjozNzoyMC4zNTYyNzU
TEAM_TOKEN = 502552739fda4ed9c797b08bc926d929_MjMxMDQ3MjAxMy0wNi0wOCAwMzoyNDoyMS41MjYyMTI

testflight: $(TESTFLIGHT_RESULT)

$(IPA): $(APP) $(PROVISIONING_PROFILE)
	/usr/bin/xcrun \
  -sdk iphoneos PackageApplication -v \
  "$(APP)" \
  -o "$(IPA)" \
  --sign "${DEVELOPER_NAME}" \
  --embed "${PROVISIONING_PROFILE}"

$(TESTFLIGHT_RESULT): $(IPA)
	curl http://testflightapp.com/api/builds.json \
    -F file=@$(IPA) \
    -F api_token='$(API_TOKEN)' \
    -F team_token='$(TEAM_TOKEN)' \
    -F notes='This build was uploaded via the upload API' \
    -F notify=True \
    -F distribution_lists='Me' \
	> $@
	cat $@
