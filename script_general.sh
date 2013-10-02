#!/bin/bash

# =================     Set environment variables     ===========
export WORKSPACE="-workspace Framework/SparkFramework.xcworkspace"
export PROJECT="-project tools/SparkAttributesCodeGenerator/SparkAttributesCodeGenerator.xcodeproj"
if [[ $SPARK_SCHEME == SparkAttributesCodeGenerator ]]; then export PATCH_FOR_PROJECT_OR_WORKSPACE=$PROJECT; else export PATCH_FOR_PROJECT_OR_WORKSPACE=$WORKSPACE; fi

# =================     Run build, test and oclint check     ===========
xctool $PATCH_FOR_PROJECT_OR_WORKSPACE -scheme $SPARK_SCHEME -reporter pretty -reporter json-compilation-database:compile_commands.json build
if [[ $SPARK_SCHEME != SparkAttributesCodeGenerator ]]; then xctool $WORKSPACE -scheme $SPARK_SCHEME test -sdk iphonesimulator; fi	
oclint-json-compilation-database -- -rc=LONG_LINE=300 -rc=LONG_VARIABLE_NAME=50 -max-priority-2 30 -max-priority-3 80
