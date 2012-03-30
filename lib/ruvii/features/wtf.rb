# # wtf?
require "ruvii/dependencies"

module Ruvii::WTF

  # It'd be nice to know just where the fuck that method is defined, wouldn't it?
  #
  # When you're lost, don't forget that you can ask WTF:
  #
  #   some_obj.wtf? :method_name
  def wtf?(sym, print=true)
    scope = ::Ruvii::WTF

    # Raises on missing method
    method = self.singleton_class.instance_method(sym)

    if method.source_location
      file, line = method.source_location
      location   = "#{scope.green file}:#{scope.yellow line.to_s}"

      # Nicely highlighted source.  We want to give a bit of context around the definition.
      source = scope.method_source_lines(file, line).map { |line_num, line_text, is_target|
        # The specific def line is also called out
        line_text = scope.green(line_text) if is_target
        "  #{scope.white line_num} > #{line_text}"
      }.join("\n")
    else
      location = scope.red "Unknown Location"
    end

    method_desc = scope.method_desc(method, self, sym)

    message  = "#{scope.yellow method_desc} defined at #{location}"
    message += "\n\n#{source}" if source

    scope.emit message, print
  end

  class << self
    include Term::ANSIColor

    # Our default mode is to just print out the message; we assume that you're running this from
    # a terminal (either in IRB, or via a script)
    def emit(message, print)
      message = message.strip_heredoc.strip

      if print
        puts
        puts message
        puts

        # getting a huge string back in IRB is annoying as fawk.
        return nil
      end

      # Alternatively, if you turn of printing you *can* get the string back.  Helpful for scripting
      # or testing.
      self.uncolored message
    end

    # Creates the pretty form of a method.
    def method_desc(method, obj, sym)
      # Method#inspect does a pretty good job of this.  Class(Module)#method or Class#method
      base = method.inspect[/^\#<\S+ (.+)\#.+>$/, 1]
      # However, singletons are a bit goofy and look like #<Class:Class>
      base = $1 if base =~ /^\#<Class:(.+)>$/

      if obj.is_a? Module
        # Rewrite singleton calls so that we have . instead of #
        base = base.gsub('Class(', "#{obj.name}(") if obj.is_a?(Class) && obj.name

        "#{base}.#{sym}"
      else
        "#{base}##{sym}"
      end
    end

    # Attempts to extract useful context around a method definition
    #
    # Returns an array of tuples: `[line_num, line_text, is_target]`
    #
    # Line num is a string, and padded
    def method_source_lines(file, line_num, context=5)
      # Yeah, we're not memory efficient here.
      lines  = Array(File.open(file))
      result = []

      min_index = line_num - context - 1
      max_index = line_num + context

      max_width = (max_index + 1).to_s.length

      (min_index...max_index).each do |index|
        result << [(index + 1).to_s.rjust(max_width), lines[index].rstrip, index == line_num - 1]
      end

      result
    end

  end

end

Object.send :include, Ruvii::WTF
