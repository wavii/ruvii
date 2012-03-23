require "rubygems"
require "spork"
require "spork/ext/ruby-debug"

Spork.prefork do
  require "rspec"
  require "ruvii/dependencies"

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
  end
end

Spork.each_run do
  # The rspec test runner executes the specs in a separate process; plus it's nice to have this
  # generic flag for cases where you want coverage running with guard.
  if ENV["COVERAGE"]
    require "simplecov" # This executes .simplecov
  end
end
