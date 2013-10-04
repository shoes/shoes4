require 'shoes/spec_helper'

shared_examples_for "basic background" do
  it "retains app" do
    subject.app.should eq(app)
  end

  it "creates gui object" do
    subject.gui.should_not be_nil
  end
end

describe Shoes::Background do
  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  let(:parent) { Shoes::Flow.new(app, app) }
  let(:blue)  { Shoes::COLORS[:blue] }
  let(:app) { Shoes::App.new }
  let(:opts){ {left: left, top: top, width: width, height: height, color: blue} }
  subject { Shoes::Background.new(app, parent, blue, opts) }

  it_behaves_like "basic background"
  it_behaves_like "object with style"
  it_behaves_like "object with dimensions"

  describe "relative dimensions from parent" do
    let(:relative_opts) { { left: left, top: top, width: relative_width, height: relative_height } }
    subject { Shoes::Background.new(app, parent, blue, relative_opts) }

    it_behaves_like "object with relative dimensions"
  end
end
