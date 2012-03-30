# We cherry-pick the few specific active support features that this gem depends on.
require "active_support/concern"
require "active_support/core_ext/string/strip"

# Additional dependencies
require "term/ansicolor"

module Ruvii
  # A dependency for all of our individual extensions is that the Ruvii module is defined.
  # Less typing!
end
