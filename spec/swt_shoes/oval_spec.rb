require 'swt_shoes/spec_helper'

describe Shoes::Swt::Oval do
  let(:container) { double('container', disposed?: false) }
  let(:app) { double('app', real: container, add_paint_listener: true) }
  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:dsl) { double("dsl object", hidden: false).as_null_object }

  subject {
    Shoes::Swt::Oval.new(dsl, app, left, top, width, height)
  }

  it_behaves_like "paintable"
  it_behaves_like "movable shape", 10, 20

  describe "painter" do
    include_context "painter context"

    let(:shape) { Shoes::Swt::Oval.new(dsl, app, left, top, width, height) }
    subject { Shoes::Swt::Oval::Painter.new(shape) }

    it_behaves_like "fill painter"
    it_behaves_like "stroke painter"

    it "creates oval clipping area" do
      mock_path = double("path")
      ::Swt::Path.stub(:new) { mock_path }
      mock_path.should_receive(:add_arc).with(left, top, width, height, 0, 360)
      subject.clipping
    end

    it "sets clipping area" do
      gc.should_receive(:set_clipping)
      subject.paint_control(event)
    end

    it "fills" do
      gc.should_receive(:fill_gradient_rectangle)
      subject.paint_control(event)
    end

    specify "draws oval" do
      gc.should_receive(:draw_oval).with(left+sw/2, top+sw/2, width-sw, height-sw)
      subject.paint_control(event)
    end
  end
end

