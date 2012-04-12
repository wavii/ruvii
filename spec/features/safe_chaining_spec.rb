require "ruvii/features/safe_chaining"

describe "Safe chaining with #n" do

  it "should allow the happy case" do
    " ohai ".n.strip.n.upcase.should == "OHAI"
  end

  it "should allow the happy case with blocks" do
    [1,2,3].n.map { |i| i + 5 }.map { |i| i - 3 }.should == [3,4,5]
  end

  it "should suppress an immediate failiure" do
    "asdf".n[5].should == nil
  end

  it "should suppress a deep failiure" do
    {foo: []}.n[:foo].n[1].n.not_here.n.or_here.should == nil
  end

  it "should suppress properly with blocks" do
    nil.n.thing { |c| "hi" }.should == nil
  end

  it "should be nil?" do
    nil.n.nil?.should == true
  end

  it "should have a nil id, even w/ whiny nils enabled" do
    NilClass.class_eval do
      def id; raise "whiny!"; end
    end

    nil.n.id.should == nil
  end

  it "should not treat false as nil" do
    expect { false.n.bad_method }.to raise_error
  end

end
