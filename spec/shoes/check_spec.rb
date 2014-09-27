require 'shoes/spec_helper'

describe Shoes::Check do
  include_context "dsl app"

  subject { Shoes::Check.new(app, parent, input_opts, input_block) }

  it_behaves_like "checkable"
  it_behaves_like "object with state"
  it_behaves_like "object with style" do
    let(:subject_without_style) { Shoes::Check.new(app, parent) }
    let(:subject_with_style) { Shoes::Check.new(app, parent, arg_styles) }
  end

  describe "dimensions" do
    let(:left) { 10 }
    let(:top) { 20 }
    let(:width) { 100 }
    let(:height) { 200 }
    let(:input_opts){ {left: left, top: top, width: width, height: height} }
    subject { Shoes::Check.new(app, parent, input_opts) }

    it_behaves_like "object with dimensions"

    describe "takes relative dimensions from parent" do
      subject { Shoes::Check.new(app, parent, relative_opts) }
      it_behaves_like "object with relative dimensions"
    end

    describe "negative dimensions" do
      subject { Shoes::Check.new(app, parent, negative_opts) }
      it_behaves_like "object with negative dimensions"
    end
  end
end
