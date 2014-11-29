require 'shoes/spec_helper'

shared_examples_for "basic star" do
  it "retains app" do
    expect(subject.app).to eq(app)
  end

  it "creates gui object" do
    expect(subject.gui).not_to be_nil
  end
end

describe Shoes::Star do
  include_context "dsl app"

  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 100 }
  let(:height) { 100 }

  subject { Shoes::Star.new(app, parent, left, top, 5, 50, 30) }

  it_behaves_like "basic star"
  it_behaves_like "object with style" do
    let(:subject_without_style) { Shoes::Star.new(app, parent, left, top, 5, 50, 30) }
    let(:subject_with_style) { Shoes::Star.new(app, parent, left, top, 5, 50, 30, arg_styles) }
  end

  it_behaves_like "object with dimensions"
  it_behaves_like "movable object"
  it_behaves_like 'object with parent'

  describe "in_bounds?" do
    it "in bounds" do
      expect(subject.in_bounds?(10, 10)).to be_true
    end

    it "out of bounds" do
      expect(subject.in_bounds?(100, 100)).to be_false
    end
  end
end
