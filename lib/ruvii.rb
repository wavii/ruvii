# Ruvii's philosophy is that it only contains utilities that you use on a daily basis.
#
# These features should also be lightweight, stateless and highly componentized.  We use this to
# rationalize loading everything on a `require "ruvii"`.  Aka, stick this in your Gemfile, and
# that's all the configuration required.

# However, all the features of Ruvii are broken out into distinct categories that you can cherry
# pick if you really want to.
require "ruvii/version"
require "ruvii/dependencies"
require "ruvii/core_ext"
require "ruvii/safe_chaining"
