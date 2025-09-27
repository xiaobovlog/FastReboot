#!/bin/bash

set -e

cd "$(dirname "$0")"

WORKING_LOCATION="$(pwd)"
APPLICATION_NAME=FastReboot
CONFIGURATION=Debug

cd build
if [ -e "$APPLICATION_NAME.tipa" ]; then
rm "$APPLICATION_NAME.tipa"
fi

# Build .app
xcodebuild -project "$WORKING_LOCATION/$APPLICATION_NAME.xcodeproj" \
    -scheme FastReboot \
    -configuration Debug \
    -derivedDataPath "$WORKING_LOCATION/build/DerivedData" \
    -destination 'generic/platform=iOS' \
    ONLY_ACTIVE_ARCH="NO" \
    CODE_SIGNING_ALLOWED="NO" \
    

DD_APP_PATH="$WORKING_LOCATION/build/DerivedData/Build/Products/$CONFIGURATION-iphoneos/$APPLICATION_NAME.app"
TARGET_APP="$WORKING_LOCATION/build/$APPLICATION_NAME.app"
cp -r "$DD_APP_PATH" "$TARGET_APP"

# Remove signature
codesign --remove "$TARGET_APP"
if [ -e "$TARGET_APP/_CodeSignature" ]; then
    rm -rf "$TARGET_APP/_CodeSignature"
fi
if [ -e "$TARGET_APP/embedded.mobileprovision" ]; then
    rm -rf "$TARGET_APP/embedded.mobileprovision"
fi

cd "$WORKING_LOCATION/RootHelper"
make clean
make
cp $WORKING_LOCATION/RootHelper/.theos/obj/debug/ipccroothelper $WORKING_LOCATION/build/FastReboot.app/ipccroothelper
cd -

# Add entitlements
echo "Adding entitlements"
ldid -S"$WORKING_LOCATION/entitlements.plist" "$TARGET_APP/$APPLICATION_NAME"


# Package .ipa
rm -rf Payload
mkdir Payload
cp -r FastReboot.app Payload/FastReboot.app
zip -vr FastReboot.tipa Payload
rm -rf FastReboot.app
rm -rf Payload
