#!/bin/bash

EXIT_STATUS=0

# =================     Set environment variables     ===========
export WORKSPACE="-workspace Framework/ROADFramework.xcworkspace"
export PROJECT="-project tools/ROADAttributesCodeGenerator/ROADAttributesCodeGenerator.xcodeproj"
if [[ $PROJECT_SCHEME == ROADAttributesCodeGenerator ]]; then export PATCH_FOR_PROJECT_OR_WORKSPACE=$PROJECT; else export PATCH_FOR_PROJECT_OR_WORKSPACE=$WORKSPACE; fi

# =================     Install cpp-coveralls    ===========
sudo easy_install cpp-coveralls > /dev/null

# =================     Run build, test and oclint check     ===========
xctool $PATCH_FOR_PROJECT_OR_WORKSPACE -scheme $PROJECT_SCHEME -reporter pretty -reporter json-compilation-database:compile_commands.json build || EXIT_STATUS=$?
if [[ $PROJECT_SCHEME != ROADAttributesCodeGenerator ]]; then xctool $WORKSPACE -scheme $PROJECT_SCHEME test -sdk iphonesimulator6.1 || EXIT_STATUS=$?; fi	

# =================     Download oclint, unzip    ===========

wget https://www.dropbox.com/s/y0dqo9ni6myoevy/oclint-0.9.dev.da383ab.zip > /dev/null
unzip oclint-0.9.dev.da383ab.zip > /dev/null

# =================     Remove necessary rules from "lib/oclint/rules/" folder of oclint     ===========
rm $('pwd')/oclint-0.9.dev.da383ab/lib/oclint/rules/libUnusedMethodParameterRule.dylib
rm $('pwd')/oclint-0.9.dev.da383ab/lib/oclint/rules/libFeatureEnvyRule.dylib
rm $('pwd')/oclint-0.9.dev.da383ab/lib/oclint/rules/libObjCAssignIvarOutsideAccessorsRule.dylib

# =================     Setup oclint    ===========
OCLINT_HOME=$('pwd')/oclint-0.9.dev.da383ab
PATH=$OCLINT_HOME/bin:$PATH

# =================     Run oclint    ===========
oclint-json-compilation-database -- -rc=LONG_LINE=500 -rc=LONG_VARIABLE_NAME=50 -max-priority-2 30 -max-priority-3 152 || EXIT_STATUS=$?

exit $EXIT_STATUS
