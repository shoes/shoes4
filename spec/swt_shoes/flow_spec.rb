require "spec_helper"

require 'swt_shoes/spec_helper'

describe SwtShoes::Flow do

  class FlowShoeLaces
    include SwtShoes::Flow
    attr_accessor :parent_gui_container, :gui_container, :opts, :width, :height, :margin
  end

  let(:parent_gui_container) { Swt.display }
  let(:mock_slot) { mock(:slot) }
  let(:shoelace) {
    shoelace = FlowShoeLaces.new
    shoelace.parent_gui_container = parent_gui_container
    shoelace
  }

  describe "gui_flow_init" do

    before do
      Swt::Widgets::Composite.should_receive(:new).with(parent_gui_container, anything).and_return mock_slot
    end
    it "should create a composite and set accessor" do
      mock_slot.stub(:setLayout)
      shoelace.gui_flow_init
      shoelace.gui_container.should == mock_slot
    end

    it "should use a RowLayout" do
      mock_slot.should_receive(:setLayout).with(an_instance_of(Swt::Layout::RowLayout))
      shoelace.gui_flow_init
    end

    it "should set height and width" do
      mock_slot.stub(:setLayout)
      shoelace.width = 111
      shoelace.height = 129
      mock_slot.should_receive(:setSize).with(111, 129)
      shoelace.gui_flow_init
    end

    it "should set margins" do
      mock_slot.stub(:setLayout)
      shoelace.margin = 131
      mock_layout = mock(:layout)
      Swt::Layout::RowLayout.should_receive(:new).and_return mock_layout
      mock_layout.should_receive(:marginTop=).with 131
      mock_layout.should_receive(:marginRight=).with 131
      mock_layout.should_receive(:marginBottom=).with 131
      mock_layout.should_receive(:marginLeft=).with 131
      shoelace.gui_flow_init

    end
  end

  describe "git_flow_add_to_parent" do
    #it "should add gui_container to parent_gui_container" do
    #  gui_container = mock(:gui_container)
    #  shoelace.gui_container = gui_container
    #  parent_gui_container.should_receive(:add).with(gui_container)
    #  shoelace.gui_flow_add_to_parent
    #end
  end

end

