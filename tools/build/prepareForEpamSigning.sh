#!/bin/sh

# This script updates the:
#	- bundle id 
#	- application schema value 
# in the .plist file

PlistPath=`cat build.properties | grep "plist.location" | cut -d '=' -f 2`

echo "Preparing EPAM version ..."

CurrentBundleId=`/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" $PlistPath`

echo "... changing $CurrentBundleId to com.epam.$CurrentBundleId"

# Prefixing the bundle id with com.epam.
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.epam.$CurrentBundleId" $PlistPath
/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLName com.epam.$CurrentBundleId" $PlistPath

# replace the old plist file with the new one
echo "EPAM version prepared."