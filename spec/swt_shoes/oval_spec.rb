require 'swt_shoes/spec_helper'

describe Shoes::Swt::Oval do
  let(:container) { double('container', is_disposed?: false) }
  let(:gui) { double('gui', real: container).as_null_object }
  let(:app) { double('app', gui: gui, dsl: dsl).as_null_object }
  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:dsl) { double("dsl object", hidden: false, rotate: 0, left: left, top: top, width: width, height: height).as_null_object }
  let(:real_dsl) {::Shoes::Oval.new app, left, top, width, height}

  subject {
    Shoes::Swt::Oval.new(real_dsl, app)
  }

  it_behaves_like "paintable"
  it_behaves_like "togglable"
  it_behaves_like 'clickable backend'

  describe "painter" do
    include_context "painter context"

    let(:shape) { Shoes::Swt::Oval.new(dsl, app) }
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

