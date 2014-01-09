require 'shoes/spec_helper'

shared_examples_for "basic background" do
  it "retains app" do
    expect(background.app).to eq(app)
  end

  it "creates gui object" do
    expect(background.gui).not_to be_nil
  end
end

describe Shoes::Background do
  include_context "dsl app"

  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  let(:blue)  { Shoes::COLORS[:blue] }
  let(:input_opts){ {left: left, top: top, width: width, height: height, color: blue} }
  subject(:background) { Shoes::Background.new(app, parent, blue, input_opts) }

  it_behaves_like "basic background"
  it_behaves_like "object with style"
  it_behaves_like "object with dimensions"

  describe "relative dimensions from parent" do
    subject { Shoes::Background.new(app, parent, blue, relative_opts) }
    it_behaves_like "object with relative dimensions"
  end

  context "negative dimensions" do
    subject { Shoes::Background.new(app, parent, blue, negative_opts) }
    it_behaves_like "object with negative dimensions"
  end
end
