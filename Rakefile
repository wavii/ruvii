#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"

# We want to force ourselves to review code coverage results.
task :default => :coverage

RSpec::Core::RakeTask.new(:spec) do |task|
  # No special configuration yet.
end

desc "Run tests with code coverage"
task :spec_with_coverage do
  prev = ENV["COVERAGE"]
  ENV["COVERAGE"] = "yes"

  Rake::Task["spec"].execute

  ENV["COVERAGE"] = prev
end

desc "Run tests with code coverage and open the results"
task :coverage => :spec_with_coverage do
  `open coverage/index.html`
end

desc "Boot up an IRB console w/ ruvii preloaded"
task :console do
  require "ruvii"
  require "irb"

  # IRB parses ARGV on start; let's make it think that its in its own environment
  ARGV.clear
  IRB.start
end
