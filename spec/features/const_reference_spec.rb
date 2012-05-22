require "ruvii/features/const_reference"

module A
  module B
    module C
      class D
        module E
          def self.thing
            @thing ||= 0
            @thing  += 1
          end
        end
      end
    end
  end
end

describe Ruvii::ConstReference do

  it "should provide a convenient and nearly transparent wrapper to a class" do
    str_ref = described_class.new(String)

    str_ref.inspect.should == "String"
    str_ref.new.should == ""
  end

  it "should support string-like names" do
    str_ref = described_class.new('String')

    str_ref.inspect.should == 'String'
    str_ref.new.should == ''

    array_ref = described_class.new(:Array)

    array_ref.inspect.should == 'Array'
    array_ref.new.should == []
  end

  it "should fully identify the class" do
    arr_ref = described_class.new(Array)

    arr_ref.object_id.should == Array.object_id
    arr_ref.__id__.should    == Array.__id__
    arr_ref.name.should      == Array.name
    arr_ref.inspect.should   == Array.inspect
    arr_ref.hash.should      == Array.hash
    arr_ref.should           == Array

    arr_ref.should eql(Array)
    arr_ref.should === []

    arr_ref.send(:object_id).should == Array.object_id

    arr_ref.is_a?(Class).should        == true
    arr_ref.kind_of?(Class).should     == true
    arr_ref.instance_of?(Class).should == true

    arr_ref.singleton_class.should == Array.singleton_class
  end

  it "should not freak out if you ask it to wrap Object" do
    obj_ref = described_class.new(Object)
    obj_ref.inspect.should == "Object"
  end

  it "should raise when you pass a non-constant" do
    expect { described_class.new("") }.to raise_error(NameError)
  end

  it "should raise if you give it an unreferencable constant" do
    expect { described_class.new(Class.new) }.to raise_error(NameError)
  end

  it "should find deeply nested constants" do
    deep_ref = described_class.new(A::B::C::D::E)
    deep_ref.name.should == "A::B::C::D::E"
  end

  it "should provide a helper method for sane use" do
    const_ref(A::B::C::D::E).name.should == "A::B::C::D::E"
  end

  it "should work when you yank the constant out from under it" do
    module Foo; end
    orig_id = Foo.object_id

    foo_ref = described_class.new(Foo)
    foo_ref.object_id.should == orig_id

    Object.send :remove_const, :Foo
    module Foo; end

    Foo.object_id.should_not == orig_id
    foo_ref.object_id.should == Foo.object_id
  end

  it "should raise an appropriate error if we yank the constant out and don't replace it" do
    module Foo; end
    foo_ref = described_class.new(Foo)

    Object.send :remove_const, :Foo

    expect { foo_ref.inspect }.to raise_error(NameError, "uninitialized constant Foo")
  end

  it "should be fast" do
    deep_ref = described_class.new(A::B::C::D::E)

    start = Time.now
    10000.times { A::B::C::D::E.thing }
    naked_duration = Time.now - start

    start = Time.now
    10000.times { deep_ref.thing }
    wrapped_duration = Time.now - start

    call_overhead = wrapped_duration / naked_duration
    call_overhead.should <= 10.0
  end

end
