#!/bin/bash

mkdir $DEPLOY_DIRECTORY

# Run swift test, grabbing the last line of the output (the code coverage path) then copying it to the file below.
cp $(swift test --enable-code-coverage --show-codecov-path | tail -n1) deploy/codecov.json
