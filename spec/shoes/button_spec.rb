require "shoes/spec_helper"

#require 'support/shared_examples_for_common_elements_spec'

describe Shoes::Button do

  let(:input_block) { Proc.new {} }
  let(:input_opts) { {:width => 131, :height => 137, :margin => 143} }
  subject { Shoes::Button.new("gui_container", "text", input_opts, input_block) }

  it_behaves_like "movable object"

  describe "initialize" do
    it "should set accessors" do
      button = subject
      button.gui_container.should == "gui_container"
      button.click_event_lambda.should == input_block
      button.text.should == "text"
      button.width.should == 131
      button.height.should == 137
    end
  end
end
