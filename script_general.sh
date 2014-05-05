#!/bin/bash

EXIT_STATUS=0

# =================     Set environment variables     ===========
export WORKSPACE="-workspace Framework/ROADFramework.xcworkspace"

# =================     Install cpp-coveralls    ===========
sudo easy_install cpp-coveralls > /dev/null

# =================     Install cocoa pods    ===========
cd Framework
pod install
cd ..

# =================     Run build, test and oclint check     ===========
xctool $WORKSPACE -scheme $PROJECT_SCHEME -reporter pretty -reporter json-compilation-database:compile_commands.json build || EXIT_STATUS=$?
xctool $WORKSPACE -scheme $PROJECT_SCHEME test -sdk iphonesimulator7.1 -destination "platform=iOS Simulator,OS=7.1,name=iPhone Retina (4-inch)" || EXIT_STATUS=$?

# =================     Download oclint, unzip    ===========

wget https://www.dropbox.com/s/gd890zrni02gkoy/oclint-0.9.dev.90b12ca.zip > /dev/null
unzip oclint-0.9.dev.90b12ca.zip > /dev/null

# =================     Setup oclint    ===========
OCLINT_HOME=$('pwd')/oclint-0.9.dev.90b12ca
PATH=$OCLINT_HOME/bin:$PATH

# =================     Run oclint    ===========
oclint-json-compilation-database -e ROADGeneratedAttributes -e Pods -- -rc=LONG_LINE=500 -rc=LONG_VARIABLE_NAME=50 -max-priority-2 30 -max-priority-3 152 || EXIT_STATUS=$?

exit $EXIT_STATUS
