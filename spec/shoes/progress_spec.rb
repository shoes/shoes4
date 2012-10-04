require 'shoes/spec_helper'

describe Shoes::Progress do
  subject { Shoes::Progress.new(parent, input_opts, input_block) }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { {} }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app: app}

  it { should respond_to :fraction }
  it { should respond_to :fraction= }

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
end
