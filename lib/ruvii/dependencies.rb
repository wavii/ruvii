# # External Dependencies

# All Ruvii dependencies are consolidated into `ruvii/dependencies`; this allows us to speed up
# tests (for, say, [spork](https://github.com/sporkrb/spork)).  It also serves as a canonical
# reference of what we use.

# We cherry-pick the few specific ActiveSupport features that this gem depends on.
require "active_support/concern"
require "active_support/core_ext/string/strip"

# [wtf?](features/wtf.html) uses this for pretty output.
require "term/ansicolor"

# A dependency for all of our individual extensions is that the Ruvii module is defined.
module Ruvii
  # Less typing!
end
