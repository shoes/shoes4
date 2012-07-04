require 'shoes/spec_helper'

describe Shoes::Check do
  subject { Shoes::Check.new(parent, input_opts, input_block) }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { {} }
  let(:parent) { double("parent").as_null_object }

  it "should respond to the right methods" do
    s = subject
    s.should respond_to :checked=
    s.should respond_to :checked?
    s.should respond_to :focus
  end
end
