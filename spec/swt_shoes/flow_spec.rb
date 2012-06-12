require 'swt_shoes/spec_helper'

describe Shoes::Swt::Flow do
  let(:dsl) { double('dsl') }
  let(:real) { double('real') }
  let(:parent_real) { double('parent_real') }
  let(:parent) { double('parent', :real => parent_real) }
  subject { Shoes::Swt::Flow.new(dsl, parent) }

  describe "#initialize" do
    before do
      ::Swt::Widgets::Composite.should_receive(:new).with(parent_real, anything).and_return(real)
      real.stub(:setLayout)
      dsl.stub(:margin)
      dsl.stub(:width)
      dsl.stub(:height)
    end

    it "creates a composite and set accessor" do
      subject.real.should be(real)
    end

    it "uses a RowLayout" do
      real.should_receive(:setLayout).with(an_instance_of(::Swt::Layout::RowLayout))
      subject
    end

    context "when dsl has height and width" do
      before :each do
        dsl.stub(:width) { 111 }
        dsl.stub(:height) { 129 }
      end

      it "sets height and width" do
        real.should_receive(:setSize).with(111, 129)
        subject
      end
    end

    context "when dsl does not have height and width" do
      it "doesn't set height and width" do
        real.should_not_receive(:setSize)
        subject
      end
    end

    context "dsl has margin" do
      let(:mock_layout) { double(:layout) }
      let(:margin) { 131 }

      before :each do
        dsl.stub(:margin) { margin }
        ::Swt::Layout::RowLayout.should_receive(:new).and_return mock_layout
      end

      it "sets margins" do
        mock_layout.should_receive(:marginTop=).with margin
        mock_layout.should_receive(:marginRight=).with margin
        mock_layout.should_receive(:marginBottom=).with margin
        mock_layout.should_receive(:marginLeft=).with margin
        subject
      end
    end
  end

  describe "#add_to_parent" do
    #it "should add gui_container to parent_gui_container" do
    #  gui_container = mock(:gui_container)
    #  shoelace.gui_container = gui_container
    #  parent_gui_container.should_receive(:add).with(gui_container)
    #  shoelace.gui_flow_add_to_parent
    #end
  end

end

