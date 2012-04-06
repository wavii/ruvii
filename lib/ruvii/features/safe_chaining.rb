# # Safe Chaining
require "ruvii/dependencies"

# Succint `&&` chaining.
#
# Stop writing code like:
#
#     thing && thing.foo && thing.foo.bar
#
# Instead, chain it:
#
#     thing.n.foo.n.bar
module Ruvii::SafeChaining

  # ## Implementation

  # This guy is responsible for stubbing out a fake interface for the method in question.
  #
  # It's a silent nil!  You Objective-C folk have to be happy about this.
  class ChainedNil < BasicObject

    def method_missing(sym, *args, &block)
      return nil unless nil.respond_to? sym

      nil.send(sym, *args, &block)
    end

  end

  module Object

    # Enable the happy case; we just return ourselves, and away you go!
    def n
      self
    end

  end

  module NilClass

    # The not-so-happy case.
    def n
      COMMON_CHAINED_NIL
    end

  end

  # One ChainedNil behaves like any other, so let's save some cycles.
  COMMON_CHAINED_NIL = ChainedNil.new

end

Object.send   :include, Ruvii::SafeChaining::Object
NilClass.send :include, Ruvii::SafeChaining::NilClass
