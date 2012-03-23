require "ruvii/core_ext/hash"

describe "Hash.default" do

  it "should work for immutable values" do
    hash = Hash.default { 123 }
    hash.keys.should == []
    hash[:a].should == 123
    hash.keys.should == [:a]
  end

  it "should not share mutable collections" do
    hash = Hash.default { [] }
    hash[:a] << 1
    hash[:b] << 2
    hash[:a].should == [1]
    hash[:b].should == [2]
  end

  it "should properly nest" do
    hash = Hash.default { Hash.default { [] } }

    hash[:a].should be_a(Hash)
    hash[:a][:b].should be_an(Array)

    hash[:a][:b] += [1, 2, 3]
    hash[:a][:c].should == []
    hash[:d][:b].should == []
  end

  it "should raise if no block is given" do
    proc { Hash.default }.should raise_error
  end

end
