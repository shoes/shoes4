require 'shoes/spec_helper'

describe Shoes::Line do
  before :each do
    Shoes::Mock::Line.any_instance.stub(:real) { mock( size:
      mock(x: 90, y: 45) ) }
  end

  describe "basic" do
    subject { Shoes::Line.new(20, 23, 300, 430) }
    it_behaves_like "object with stroke"
    it_behaves_like "movable object"
  end

  shared_examples_for "basic line" do
    it { should be_kind_of(Shoes::Line) }
    its(:top) { should eq(15) }
    its(:left) { should eq(10) }
    its(:width) { should eq(90) }
    its(:height) { should eq(45) }
  end

  context "created left-to-right, top-to-bottom" do
    subject { Shoes::Line.new(10, 15, 100, 60) }
    it_behaves_like "basic line"
  end

  context "specified right-to-left, top-to-bottom" do
    subject { Shoes::Line.new(100, 15, 10, 60) }
    it_behaves_like "basic line"
  end

  context "specified right-to-left, bottom-to-top" do
    subject { Shoes::Line.new(100, 60, 10, 15) }
    it_behaves_like "basic line"
  end

  context "specified left-to-right, bottom-to-top" do
    subject { Shoes::Line.new(10, 60, 100, 15) }
    it_behaves_like "basic line"
  end
end
