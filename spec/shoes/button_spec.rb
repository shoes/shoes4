require "shoes/spec_helper"

#require 'support/shared_examples_for_common_elements_spec'

describe Shoes::Button do

  let(:left)   { 13 }
  let(:top)    { 44 }
  let(:width)  { 131 }
  let(:height) { 137 }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { {:left => left, :top => top, :width => width, :height => height, :margin => 143, :state => "disabled"} }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app }

  subject { Shoes::Button.new(app, parent, "text", input_opts, input_block) }

  it_behaves_like "movable object"
  it_behaves_like "object with state"
  it_behaves_like "object with dimensions"

  it { should respond_to :click }
  it { should respond_to :focus }

  describe "initialize" do
    it "should set accessors" do
      button = subject
      button.parent.should == parent
      button.blk.should == input_block
      button.text.should == "text"
      button.width.should == 131
      button.height.should == 137
      button.state.should == "disabled"
    end
  end

  describe "relative dimensions" do
    subject { Shoes::Button.new(app, parent, "text", relative_opts, input_block) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject { Shoes::Button.new(app, parent, "text", negative_opts, input_block) }
    it_behaves_like "object with negative dimensions"
  end
end
