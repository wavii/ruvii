require "ruvii/dependencies"

module Ruvii::Module

  # Memoize a property.
  #
  # 99% of the time we memoize expensive-to-load properties; this makes that case super easy, while
  # also dealing with the ||= gotcha.
  def memoize(symbol, &block)
    memoizer_name = "#{symbol}_unmemoized"
    storage_name  = "@_#{symbol}_memoized"

    # As a rule, never use define_method because it ends up creating a method w/ the extra weight of
    # an additional closure.  We get away not creating a new closure here by passing the block
    # through without any wrapping.
    define_method(memoizer_name, &block)

    # Instead of define_method, you should be doing a class_eval or module_eval like the following:
    module_eval <<-end_eval, __FILE__, __LINE__
      def #{symbol}
        #{storage_name} = begin
          self.#{memoizer_name}
        end unless defined? #{storage_name}

        #{storage_name}
      end
    end_eval
  end

end

Module.send :include, Ruvii::Module
