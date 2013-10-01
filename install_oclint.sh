#!/bin/sh
 
curl -O http://archives.oclint.org/releases/0.7/oclint-0.7-x86_64-apple-darwin-10.tar.gz
tar -zxvf oclint-0.7-x86_64-apple-darwin-10.tar.gz
# =================     Remove necessary rules from "lib/oclint/rules/" folder of oclint     ===========
#- rm $('pwd')/oclint-0.7-x86_64-apple-darwin-10/lib/oclint/rules/libUnusedMethodParameterRule.dylib
# ======================================================================================================
OCLINT_HOME=$('pwd')/oclint-0.7-x86_64-apple-darwin-10
PATH=$OCLINT_HOME/bin:$PATH