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
