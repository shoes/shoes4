require "spec_helper"

require "white_shoes"

describe Shoes::Flow do
    

  describe "initialize" do
    it "should set accessors" do
      input_block = Proc.new {}
      input_opts = {:width => 131, :height => 137, :margin => 143}
      flow = Shoes::Flow.new("parent_container", "parent_gui_container", input_opts, input_block)
      flow.parent_container.should == "parent_container"
      flow.parent_gui_container.should == "parent_gui_container"
      flow.width.should == 131
      flow.height.should == 137
      flow.margin.should == 143
      flow.blk.should == input_block
    end
  end
  #let(:display) { SWT::Widgets::Display.getDefault }
  #let(:parent_container) { SWT::Widgets::Shell.new(display) }
  #
  #it "should have a SWT Composite" do
  #  flow = Shoes::Flow.new(parent_container)
  #  flow.container.should be_a SWT::Layouts::Composite
  #end
  #
  #it "should horizontally stack 3 widgets" do
  #  button1 = button2 = button3 = nil
  #  Shoes::Flow.new(parent_container) do
  #    button1 = button("Button1")
  #    button2 = button("Button2")
  #    button3 = button("Button3")
  #  end
  #  button1.left.should >= 0
  #  button2.left.should >= button1.left + button1.width
  #end
  #
  #it "should have a margin" do
  #  button1 = nil
  #  flow = Shoes::Flow.new(parent_container, :margin => 10) do
  #    button1 = button("Button1")
  #  end
  #  button1.top.should == 10
  #  button1.left.should == 10
  #end
  #
  #after :all do
  #  SWT::Widgets::Display.getDefault.dispose
  #end

end
