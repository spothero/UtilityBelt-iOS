# #!/bin/bash

# mkdir deploy

# set -o pipefail && 
#   env NSUnbufferedIO=YES \
#   xcodebuild \
#     -workspace "UtilityBelt.xcworkspace" \
#     -scheme "UtilityBelt" \
#     -destination "name=iPhone 11 Pro,OS=13.4.1" \
#     -resultBundlePath "./deploy/Test.xcresult" \
#     -enableCodeCoverage YES \
#     clean test \
#   | tee "./deploy/xcodebuild.log"
# #   | xcpretty

# # mkdir deploy
# # swift test -c debug --enable-test-discovery --enable-code-coverage
# # cp $(swift test --show-codecov-path) deploy/codecov.json
# bash <(curl -s https://codecov.io/bash) -J "UtilityBelt"