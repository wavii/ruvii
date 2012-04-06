require "ruvii/features/wtf"

module SomeModule
  def mixed_in_method
    "ohai"
  end
end

class Parent
  def parent_method
    "yes!"
  end
end

class Thing < Parent
  include SomeModule

  def regular_method
    "Hmm."
  end

  class << self
    include SomeModule

    def singleton_thing
      self.new
    end
  end
end

describe "Object#wtf?" do

  it "should describe directly defined instance methods" do
    result = Thing.new.wtf? :regular_method, false

    result.should include("#{__FILE__}:18")
    result.should include("Thing#regular_method")
    result.should include("def regular_method")
  end

  it "should describe inherited instance methods" do
    result = Thing.new.wtf? :parent_method, false

    result.should include("#{__FILE__}:10")
    result.should include("Thing(Parent)#parent_method")
    result.should include("def parent_method")
  end

  it "should describe mixed in instance methods" do
    result = Thing.new.wtf? :mixed_in_method, false

    result.should include("#{__FILE__}:4")
    result.should include("Thing(SomeModule)#mixed_in_method")
    result.should include("def mixed_in_method")
  end

  it "should describe singleton methods" do
    result = Thing.wtf? :singleton_thing, false

    result.should include("#{__FILE__}:25")
    result.should include("Thing.singleton_thing")
    result.should include("def singleton_thing")
  end

  it "should describe mixed in singleton methods" do
    result = Thing.wtf? :mixed_in_method, false

    result.should include("#{__FILE__}:4")
    result.should include("Thing(SomeModule).mixed_in_method")
    result.should include("def mixed_in_method")
  end

  it "should raise a sane error if a method doesn't ext" do
    proc { Thing.new.wtf? :not_here, false }.should raise_error(NameError)
  end

end
