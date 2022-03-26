#/bin/bash

RELEASE=$(cat ${PROJECT_DIR}/VERSION)
BUILD_NUMBER=$(git rev-list --count HEAD)
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $RELEASE" "${TARGET_BUILD_DIR}"/"${INFOPLIST_PATH}"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "${TARGET_BUILD_DIR}"/"${INFOPLIST_PATH}"
