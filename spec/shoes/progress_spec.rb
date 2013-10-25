require 'shoes/spec_helper'

describe Shoes::Progress do
  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  let(:input_block) { Proc.new {} }
  let(:input_opts) { { left: left, top: top, width: width, height: height } }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app}

  subject { Shoes::Progress.new(app, parent, input_opts, input_block) }

  it { should respond_to :fraction }
  it { should respond_to :fraction= }

  it_behaves_like "object with dimensions"

  context "setting fraction" do
    it "sets on gui" do
      subject.gui.should_receive(:fraction=).with(0.5)
      subject.fraction = 0.5
    end

    it "sets on self" do
      subject.fraction = 0.5
      subject.fraction.should eq 0.5
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
