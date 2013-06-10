APP = ../app/FacebookRenshu.app
IPA = $(PWD)/FacebookRenshu.ipa
DEVELOPER_NAME = iPhone Developer: Toru Hisai (2LA63FS7DX)
PROVISIONING_PROFILE = wildercard.mobileprovision

ipa: $(APP) $(PROVISIONING_PROFILE)
	/usr/bin/xcrun \
  -sdk iphoneos PackageApplication -v \
  "$(APP)" \
  -o "$(IPA)" \
  --sign "${DEVELOPER_NAME}" \
  --embed "${PROVISIONING_PROFILE}"
