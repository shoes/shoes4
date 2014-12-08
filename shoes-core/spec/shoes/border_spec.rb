require 'shoes/spec_helper'

shared_examples_for "basic border" do
  it "retains app" do
    expect(subject.app).to eq(app)
  end

  it "creates gui object" do
    expect(subject.gui).not_to be_nil
  end
end

describe Shoes::Border do
  include_context "dsl app"
  let(:parent) { Shoes::FakeElement.new nil, left, top, width, height}
  let(:opts){ {left: left, top: top, width: width, height: height} }

  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  let(:blue)  { Shoes::COLORS[:blue] }

  subject { Shoes::Border.new(app, parent, blue, opts) }

  it_behaves_like "basic border"
  it_behaves_like "object with style" do
    subject { Shoes::Border.new(app, parent, Shoes::COLORS[:black]) }
    let(:subject_without_style) { Shoes::Border.new(app, parent, blue) }
    let(:subject_with_style) { Shoes::Border.new(app, parent, blue, arg_styles) }
  end
  it_behaves_like "object with dimensions"

  describe "relative dimensions from parent" do
    subject { Shoes::Border.new(app, parent, blue, relative_opts) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject { Shoes::Border.new(app, parent, blue, negative_opts) }
    it_behaves_like "object with negative dimensions"
  end

  it {is_expected.not_to be_takes_up_space}
end
