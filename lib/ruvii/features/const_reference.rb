# # Const Reference
require "ruvii/dependencies"

class Ruvii::ConstReference < BasicObject

  # Accepts either a constant directly, or its name
  def initialize(const_or_name)
    if const_or_name.respond_to?(:name) && const_or_name.name
      const_or_name = const_or_name.name
    end

    # Basic validation
    tokens = const_or_name.to_s.split("::")
    unless tokens.size > 0 && tokens.all? { |t| /^[A-Z][a-z0-9_]*$/ =~ t }
      ::Kernel.raise ::NameError, "Ruvii::ConstReference requires validly named constants!  Got #{const_or_name.inspect}"
    end

    @split_name = tokens.map(&:to_sym)
  end

  def method_missing(sym, *args, &block)
    ::Ruvii::ConstReference.resolve(@split_name).send(sym, *args, &block)
  end

  # Fully masquerade as the referenced object
  def __id__
    ::Ruvii::ConstReference.resolve(@split_name).send(:__id__)
  end

  class << self

    def can_resolve?(split_name)
      return false unless name

      steps = [::Object]
      Array(split_name).each { |n| steps << (steps.last ? steps.last.const_get(n) : nil) }

      steps.size > 1 && steps.all?
    end

    def resolve(split_name)
      base = ::Object
      split_name.each do |name|
        break unless base
        base = base.const_get(name)
      end

      base
    end

  end

end

module Ruvii::ConstReferenceHelper
  def const_ref(*args)
    ::Ruvii::ConstReference.new(*args)
  end
end

Object.send :include, Ruvii::ConstReferenceHelper
