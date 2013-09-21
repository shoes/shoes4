require "shoes/spec_helper"

#require 'support/shared_examples_for_common_elements_spec'

describe Shoes::Button do

  let(:input_block) { Proc.new {} }
  let(:input_opts) { {:width => 131, :height => 137, :margin => 143, :state => "disabled"} }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app }

  subject { Shoes::Button.new(app, parent, "text", input_opts, input_block) }

  it_behaves_like "movable object"
  it_behaves_like "movable object with gui"
  it_behaves_like "object with state"

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
end