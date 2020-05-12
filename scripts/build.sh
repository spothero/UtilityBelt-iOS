#!/bin/bash

xcodebuild test \
  -workspace UtilityBelt.xcworkspace \
  -scheme UtilityBelt-Package \
#   -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 11 Pro,OS=13.4.1' \
  -destination 'platform=OS X,arch=x86_64' \
  | tee xcodebuild.log \
  | xcpretty

# xcodebuild | tee xcodebuild.log | xcpretty
# set -o pipefail &&
#   xcodebuild \
#     -workspace MyApp.xcworkspace \
#     -scheme "MyApp" \
#     -sdk iphonesimulator \
#     -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.1' \
#     test \
#   | xcpretty \
#     -r "html" \
#     -o "tests.html"