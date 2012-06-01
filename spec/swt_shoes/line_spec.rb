require 'swt_shoes/spec_helper'

describe Shoes::Swt::Line do
  let(:gui_container) { double("gui container") }
  let(:opts) { {:gui => {:container => gui_container}} }

  subject {
    Shoes::Line.new(10, 15, 100, 60, opts)
  }

  context "same as WhiteShoes" do
    before :each do
      gui_container.should_receive(:add_paint_listener)
    end
    it { should be_instance_of(Shoes::Line) }
    its(:top) { should eq(15) }
    its(:left) { should eq(10) }
    its(:width) { should eq(90) }
    its(:height) { should eq(45) }
  end

  context "Swt-specific" do
    let(:paint_callback) { double("paint callback") }
    let(:opts) { {:gui => {:container => gui_container, :paint_callback => paint_callback}} }

    it "uses passed-in paint callback if present" do
      gui_container.should_receive(:add_paint_listener).with(paint_callback)
      subject
    end
  end

  it_behaves_like "paintable"
  it_behaves_like "Swt object with stroke"
end
