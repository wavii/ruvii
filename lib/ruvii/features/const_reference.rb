# Const Reference
# ===============
require "ruvii/dependencies"

# Frequently when modeling your application, you want to reference your classes
# from each other at compile time (relationships between models, etc).
# 
# If you are not careful, this results in an object graph that is mostly
# connected and cumbersome.  (You don't want to load all your models to test
# just one of them, do you?!)
# 
# Additionally, if you're in the business of reloading your code (aka rails
# apps, etc), you run the risk of hanging onto stale references of your classes
# _before_ they were reloaded!
module Ruvii::ConstReferenceHelper

  # `const_ref` tries to alleviate this for you in a mostly transparent way.
  # 
  # Give it a class or a name, and it will return a reference to your target
  # constant that you can treat as if it were that constant
  # 
  #     const_ref(:MyModel)
  def const_ref(*args)
    ::Ruvii::ConstReference.new(*args)
  end

end

# This is similar to [`WeakRef`](http://www.ruby-doc.org/stdlib/libdoc/weakref/rdoc/index.html)
# except that it keys off of the name of the constant and not its object id.
# 
# You can swap out the constant (reloading it), and `const_ref` will point at
# the new definition of it.  
class Ruvii::ConstReference < BasicObject

  # The Guts
  # --------

  def initialize(const_or_name)
    # Accepts either a constant directly, or its name
    if const_or_name.respond_to?(:name) && const_or_name.name
      const_or_name = const_or_name.name
    end

    # We perform as much validation as we can, without actually referencing the
    # constant during initialization.  We don't want to force you to pull in
    # the object graph at compile time!
    tokens = const_or_name.to_s.split("::")
    unless tokens.size > 0 && tokens.all? { |t| /^[A-Z][a-z0-9_]*$/ =~ t }
      ::Kernel.raise ::NameError, "Ruvii::ConstReference requires validly named constants!  Got #{const_or_name.inspect}"
    end

    @split_name = tokens.map(&:to_sym)
  end

  # We delegate all methods through to our underlying constant, treat us like we
  # are it!
  def method_missing(sym, *args, &block)
    ::Ruvii::ConstReference.resolve(@split_name).send(sym, *args, &block)
  end

  # We go a step further and delegate the few methods we got from 
  # [`BasicObject`](http://www.ruby-doc.org/core/BasicObject.html) as well.
  [:!, :!=, :==, :__id__, :__send__, :equal?, :instance_eval, :instance_exec].each do |sym|
    class_eval <<-end_eval, __FILE__, __LINE__
      def #{sym}(*args, &block)
        ::Ruvii::ConstReference.resolve(@split_name).send(:#{sym}, *args, &block)
      end
    end_eval
  end

  class << self

    # The hard work of resolving a constant unfortunately requires that we
    # recurse through the hierarchy; no helpers/direct lookups here. 
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

Object.send :include, Ruvii::ConstReferenceHelper
