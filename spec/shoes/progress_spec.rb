require 'shoes/spec_helper'

describe Shoes::Progress do
  include_context "dsl app"
  let(:input_opts) { { left: left, top: top, width: width, height: height } }

  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  subject(:progress) { Shoes::Progress.new(app, parent, input_opts, input_block) }

  it { should respond_to :fraction }
  it { should respond_to :fraction= }

  it_behaves_like "object with dimensions"

  context "setting fraction" do
    it "sets on gui" do
      expect(progress.gui).to receive(:fraction=).with(0.5)
      progress.fraction = 0.5
    end

    it "sets on self" do
      progress.fraction = 0.5
      expect(progress.fraction).to eq(0.5)
    end
  end

  describe "relative dimensions from parent" do
    subject { Shoes::Progress.new(app, parent, relative_opts, input_block) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject { Shoes::Progress.new(app, parent, negative_opts, input_block) }
    it_behaves_like "object with negative dimensions"
  end
end
