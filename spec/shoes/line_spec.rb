require 'shoes/spec_helper'

describe Shoes::Line do
  include_context "dsl app"

  describe "basic" do
    let(:left) { 20 }
    let(:top) { 23 }
    let(:width) { 280 }
    let(:height) { 407 }

    subject { Shoes::Line.new(app, parent, Shoes::Point.new(left, top), Shoes::Point.new(300, 430), input_opts) }
    it_behaves_like "object with stroke"
    it_behaves_like "movable object"
    it_behaves_like "object with style"
    it_behaves_like "object with dimensions"
    it_behaves_like 'object with parent'
  end

  shared_examples_for "basic line" do
    it { is_expected.to be_kind_of(Shoes::Line) }
    its(:top) { should eq(15) }
    its(:left) { should eq(10) }
    its(:width) { should eq(90) }
    its(:height) { should eq(45) }
  end

  context "created left-to-right, top-to-bottom" do
    subject { Shoes::Line.new(app, app, Shoes::Point.new(10, 15), Shoes::Point.new(100, 60), input_opts) }
    it_behaves_like "basic line"
  end

  context "specified right-to-left, top-to-bottom" do
    subject { Shoes::Line.new(app, app, Shoes::Point.new(100, 15), Shoes::Point.new(10, 60), input_opts) }
    it_behaves_like "basic line"
  end

  context "specified right-to-left, bottom-to-top" do
    subject { Shoes::Line.new(app, app, Shoes::Point.new(100, 60), Shoes::Point.new(10, 15), input_opts) }
    it_behaves_like "basic line"
  end

  context "specified left-to-right, bottom-to-top" do
    subject { Shoes::Line.new(app, app, Shoes::Point.new(10, 60), Shoes::Point.new(100, 15), input_opts) }
    it_behaves_like "basic line"
  end
end
