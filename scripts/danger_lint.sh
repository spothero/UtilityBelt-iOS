#!/bin/bash

bundle exec danger d--dangerfile=Dangerfile-Lint --fail-on-errors=true --remove-previous-comments --new-comment --verbose

# lane :run_danger do |options|
#     next if options[:skip_danger]

#     # Installs SwiftFormat via Mint
#     mint_install(package: 'swiftformat') if File.exist?('../.swiftformat')

#     IS_LOCAL = !is_ci

#     # we do this due to a Bitrise bug, which is being addressed by their team
#     if !IS_LOCAL && ENV.key?('GIT_REPOSITORY_URL')
#       git_repository_url = ENV['GIT_REPOSITORY_URL']
#       ENV['GIT_REPOSITORY_URL'] = git_repository_url.sub('https://', '')
#     end

#     # we can only run danger locally if we pass in a pull request ID
#     if IS_LOCAL && options[:pr]
#       pull_request = "https://github.com/spothero/SpotHeroAPI/pull/#{options[:pr]}"
#     elsif IS_LOCAL && options[:pr].nil?
#       UI.user_error!('Unable run danger locally without specifying a pull request ID! Use the pr: lane parameter to do so.')
#       next
#     elsif !IS_LOCAL && options[:pr]
#       UI.user_error!('Pull request ID can only be specified when running danger locally.')
#     end

#     # Our Dangerfile uses this value to find the junit report generated by scan
#     ENV['DANGER_JUNIT_PATH'] = options[:junit_path]

#     danger(
#       fail_on_errors: true,
#       github_api_token: ENV['GITHUB_ACCESS_TOKEN'],
#       new_comment: true,
#       pr: pull_request,
#       verbose: true,
#     )
#   end

# #   danger --fail-on-errors=true --remove-previous-comments --new-comment --verbose