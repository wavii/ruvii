require "ruvii/safe_chaining"

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

  it "should properly behave like nil" do
    nil.n.nil?.should == true
  end

end
