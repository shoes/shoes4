require 'shoes/spec_helper'

shared_examples_for "basic border" do
  it "retains app" do
    subject.app.should eq(app)
  end

  it "creates gui object" do
    subject.gui.should_not be_nil
  end
end

describe Shoes::Border do
  include_context "dsl app"
  let(:parent) { double 'parent', absolute_left: left, absolute_top: top,
                 width: width, height: height, add_child: true,
                 element_width: width, element_height: height,
                 margin_left: 0, margin_top: 0, margin_right: 0,
                 margin_bottom: 0}
  let(:opts){ {left: left, top: top, width: width, height: height} }

  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  let(:blue)  { Shoes::COLORS[:blue] }

  subject { Shoes::Border.new(app, parent, blue, opts) }

  it_behaves_like "basic border"
  it_behaves_like "object with style"
  it_behaves_like "object with dimensions"

  describe "relative dimensions from parent" do
    subject { Shoes::Border.new(app, parent, blue, relative_opts) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject { Shoes::Border.new(app, parent, blue, negative_opts) }
    it_behaves_like "object with negative dimensions"
  end

  it {should_not be_takes_up_space}
  it {should_not be_needs_to_be_positioned}
end
