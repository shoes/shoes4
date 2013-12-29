require 'swt_shoes/spec_helper'

describe Shoes::Swt::Oval do
  include_context "swt app"

  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:dsl) {::Shoes::Oval.new shoes_app, parent, left, top, width, height}

  subject {
    Shoes::Swt::Oval.new(dsl, swt_app)
  }

  it_behaves_like "paintable"
  it_behaves_like "togglable"
  it_behaves_like 'clickable backend'

  describe "painter" do
    include_context "painter context"

    before :each do
      shape.absolute_left = left
      shape.absolute_top  = top
    end
    let(:shape) { Shoes::Swt::Oval.new(dsl, swt_app) }
    subject { Shoes::Swt::Oval::Painter.new(shape) }

    it_behaves_like "fill painter"
    it_behaves_like "stroke painter"

    it "creates oval clipping area" do
      double_path = double("path")
      ::Swt::Path.stub(:new) { double_path }
      double_path.should_receive(:add_arc).with(left, top, width, height, 0, 360)
      subject.clipping
    end

    it "fills" do
      gc.should_receive(:fill_oval)
      subject.paint_control(event)
    end

    specify "draws oval" do
      gc.should_receive(:draw_oval).with(left+sw/2, top+sw/2, width-sw, height-sw)
      subject.paint_control(event)
    end
  end
end

