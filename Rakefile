require 'bundler/setup'
require 'wwtd/tasks'
require 'bundler/gem_tasks'
require 'bump/tasks'

task :test do
  sh "ruby test/shoulda_change_matchers_test.rb"
end

task default: "wwtd:local"
