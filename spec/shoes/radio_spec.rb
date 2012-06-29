require 'shoes/spec_helper'

describe Shoes::Radio do
  subject { Shoes::Radio.new(parent, input_opts, input_block) }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { {} }
  let(:parent) { double("parent").as_null_object }

  it "should respond to the right methods" do
    s = subject
    s.should respond_to :checked=
    s.should respond_to :checked?
    s.should respond_to :focus
  end

  # should be unchecked when it's created"
  # only one radio in a group can be checked
end
