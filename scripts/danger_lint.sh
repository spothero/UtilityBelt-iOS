#!/bin/bash

# Checks if mint is installed
if [ -x "$(command -v mint)" ]; then
  # If mint is installed, set Danger's SwiftLint version to the same version in our Mintfile
    export SWIFTLINT_VERSION=$(mint run swiftlint version)
fi

# Runs Danger
bundle exec danger dry_run --dangerfile=Dangerfile-Lint --fail-on-errors=true --remove-previous-comments --new-comment --verbose