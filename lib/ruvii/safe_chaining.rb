require "ruvii/dependencies"

# Succint "&&" chaining.
#
# Stop writing code like:
#
#     thing && thing.foo && thing.foo.bar
#
# Instead, chain it:
#
#     thing.n.foo.n.bar
module Ruvii::SafeChaining

  class ChainedNil

    def method_missing(sym, *args, &block)
      # Exceptions are expensive to construct; in this instance, we use respond_to? to avoid raising
      # unnecessary ones.
      return nil unless nil.respond_to? sym

      nil.send(sym, *args, &block)
    end

  end

  module Object

    def n
      self
    end

  end

  module NilClass

    def n
      ChainedNil.new
    end
  end

end

Object.send   :include, Ruvii::SafeChaining::Object
NilClass.send :include, Ruvii::SafeChaining::NilClass
