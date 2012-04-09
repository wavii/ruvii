require "ruvii/core_ext/module"

describe "Module#memoized" do

  shared_examples_for "a module" do

    before(:each) do
      target.module_eval do
        memoize(:foo) {
          @inner_foo ||= 0
          @inner_foo += 1
        }
      end
    end

    it "should memoize basic values" do
      instance = klass.new
      2.times { instance.foo.should == 1 }
    end

    it "should work in inherited classes" do
      subklass = Class.new(klass)

      instance = subklass.new
      2.times { instance.foo.should == 1 }
    end

    it "should expose the memoizer" do
      instance = klass.new
      instance.foo_unmemoized.should == 1
      instance.foo_unmemoized.should == 2
    end

    it "places the memoized value in @memoized_property_name" do
      instance = klass.new
      instance.foo
      instance.instance_variable_get(:@memoized_foo).should == 1
    end

  end

  context "on a Module" do
    let(:target) { Module.new }
    let(:klass) {
      val = Class.new
      tar = target
      val.class_eval { include tar }
    }

    it_behaves_like "a module"
  end

  context "on a Class" do
    let(:target) { Class.new }
    let(:klass)  { target }

    it_behaves_like "a module"
  end

end
