# We cherry-pick the few specific active support features that this gem depends on.
require "active_support/concern"

module Ruvii
  # A dependency for all of our individual extensions is that the Ruvii module is defined.
  # Less typing!
end
