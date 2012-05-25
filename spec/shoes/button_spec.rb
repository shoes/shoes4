require "spec_helper"

require "white_shoes"

#require 'support/shared_examples_for_common_elements_spec'

describe Shoes::Button do

  #it_should_behave_like "A Common Element"

  describe "initialize" do
    it "should set accessors" do
      input_block = lambda {}
      input_opts = {:width => 131, :height => 137, :margin => 143}
      button = Shoes::Button.new("gui_container", "text", input_opts, input_block)
      button.gui_container.should == "gui_container"
      button.click_event_lambda.should == input_block
      button.text.should == "text"
    end
  end
end
