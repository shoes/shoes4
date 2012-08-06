require 'shoes/spec_helper'

describe Shoes::Progress do
  subject { Shoes::Progress.new(parent, input_opts, input_block) }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { {} }
  let(:parent) { double("parent").as_null_object }

  it "should respond to the right methods" do
    s = subject
    s.should respond_to :fraction
    s.should respond_to :fraction=
  end

  it "should be able to set the fraction" do
    s = subject
    s.gui.should_receive(:fraction=).with(0.5)
    s.fraction = 0.5
    s.fraction.should eql 0.5
  end
end
