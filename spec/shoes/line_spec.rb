require 'shoes/spec_helper'

describe Shoes::Line do
  let(:app_gui) { double('app gui').as_null_object }
  let(:app) { double('app', :gui => app_gui) }
  let(:opts) { {:app => app} }

  before :each do
    Shoes::Mock::Line.any_instance.stub(:real) { mock( size:
      mock(x: 90, y: 45) ) }
  end

  describe "basic" do
    subject { Shoes::Line.new(app, Shoes::Point.new(20, 23), Shoes::Point.new(300, 430), opts) }
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
    subject { Shoes::Line.new(app, Shoes::Point.new(10, 15), Shoes::Point.new(100, 60), opts) }
    it_behaves_like "basic line"
  end

  context "specified right-to-left, top-to-bottom" do
    subject { Shoes::Line.new(app, Shoes::Point.new(100, 15), Shoes::Point.new(10, 60), opts) }
    it_behaves_like "basic line"
  end

  context "specified right-to-left, bottom-to-top" do
    subject { Shoes::Line.new(app, Shoes::Point.new(100, 60), Shoes::Point.new(10, 15), opts) }
    it_behaves_like "basic line"
  end

  context "specified left-to-right, bottom-to-top" do
    subject { Shoes::Line.new(app, Shoes::Point.new(10, 60), Shoes::Point.new(100, 15), opts) }
    it_behaves_like "basic line"
  end
end
