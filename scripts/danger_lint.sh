#!/bin/bash

# Sets the SWIFTLINT_VERSION environment variable for Danger
export SWIFTLINT_VERSION=$(mint run swiftlint version)

# Runs Danger
bundle exec danger --dangerfile=Dangerfile-Lint --fail-on-errors=true --remove-previous-comments --new-comment --verbose