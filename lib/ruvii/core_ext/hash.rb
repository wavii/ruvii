require "ruvii/dependencies"

module Ruvii::Hash
  extend ActiveSupport::Concern

  module ClassMethods

    # A Hash default that is a little less awkward than Hash.new's block syntax.
    #
    # A very common pattern we use is a Hash with a default value that is a mutable collection
    # (Arrays, other Hashes, etc).  This saves us the trouble of writing out:
    #
    #     Hash.new { |h,k| h[k] = [] }
    #
    # Instead we:
    #
    #     Hash.default { [] }
    #
    # It also ensures that we always set up the correct key, and other potentially evil things.
    def default(&block)
      raise "Hash.with_default expects a block" unless block

      Hash.new { |h,k| h[k] = block.call }
    end

  end

end

Hash.send :include, Ruvii::Hash
