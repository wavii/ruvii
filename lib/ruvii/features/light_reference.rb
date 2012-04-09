# # Class Reference
require "ruvii/dependencies"

class Ruvii::LightReference < BasicObject

  def initialize(const)
    if const.respond_to?(:name) && const.name
      @split_name = const.name.to_s.split("::").map(&:to_sym)
    end

    unless ::Ruvii::LightReference.can_resolve? @split_name
      ::Kernel.raise ::TypeError, "Ruvii::LightReference can only manage named constants!"
    end
  end

  def method_missing(sym, *args, &block)
    ::Ruvii::LightReference.resolve(@split_name).send(sym, *args, &block)
  end

  # Fully masquerade as the referenced object
  def __id__
    ::Ruvii::LightReference.resolve(@split_name).send(:__id__)
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

module Ruvii::LightReferenceHelper
  def const_ref(*args)
    ::Ruvii::LightReference.new(*args)
  end
end

Object.send :include, Ruvii::LightReferenceHelper
