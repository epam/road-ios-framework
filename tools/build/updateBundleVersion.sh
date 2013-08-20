#!/bin/sh

PlistPath=`cat build.properties | grep "plist.location" | cut -d '=' -f 2`

CurrentSemiShortBundleVersion=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" $PlistPath | cut -d . -f 1,2,3`
BundleVersion=$CurrentSemiShortBundleVersion.$1

echo "Updating Bundle Version to: $BundleVersion ..."

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BundleVersion" $PlistPath

NewBundleVersion=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" $PlistPath`

echo "Updated Bundle Version to: $NewBundleVersion"