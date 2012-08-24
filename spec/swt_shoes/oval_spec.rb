require 'swt_shoes/spec_helper'

describe Shoes::Swt::Oval do
  let(:gui_container_real) { double("gui container real") }
  let(:gui_container) { double("gui container", real: gui_container_real) }
  let(:container) { double("container", gui: gui_container)  }
  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:opts) { { app: container, left: left, top: top, width: width, height: height} }
  let(:dsl) { double("dsl object").as_null_object }

  subject {
    Shoes::Swt::Oval.new(dsl, opts)
  }

  it_behaves_like "paintable"

  describe "painter" do
    include_context "paintable context"
    include_context "minimal painter context"

    let(:shape) { double("shape").as_null_object }
    subject { Shoes::Swt::Oval::Painter.new(shape) }

    #it_behaves_like "Swt object with fill"
    #it_behaves_like "Swt object with stroke"
    it_behaves_like "swt fill"
    it_behaves_like "swt stroke"

    specify "fills oval" do
      gc.should_receive(:fill_oval).with(left, top, width, height)
      subject.paint_control(event)
    end

    specify "draws oval" do
      gc.should_receive(:draw_oval).with(left, top, width, height)
      subject.paint_control(event)
    end
  end
end

