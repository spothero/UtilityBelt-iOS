#!/bin/bash

# XCODEBUILD_WORKSPACE="UtilityBelt.xcworkspace"
# XCODEBUILD_SCHEME="UtilityBelt"
# DEVICE_NAME="iPhone 11 Pro"

mkdir "output"

set -o pipefail && 
  env NSUnbufferedIO=YES \
  xcodebuild \
    -workspace "$XCODEBUILD_WORKSPACE" \
    -scheme "$XCODEBUILD_SCHEME" \
    -destination "$1" \
    -resultBundlePath "output/Test.xcresult" \
    clean test \
  | tee "output/xcodebuild.log" \
  | xcpretty

#  # This is what Bitrise runs:

# set -o pipefail && 
#   env NSUnbufferedIO=YES \ 
#   xcodebuild \
#     -workspace UtilityBelt.xcworkspace \
#     -scheme UtilityBelt \
#     build \
#     COMPILER_INDEX_STORE_ENABLE=NO \
#     test \
#     -destination name=iPhone 11 Pro,OS=13.4.1 \
#     -resultBundlePath output/Test.xcresult \
#     GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
#     GCC_GENERATE_TEST_COVERAGE_FILES=YES \
#   | xcpretty --color --report html --output output/xcode-test-results-UtilityBelt.html