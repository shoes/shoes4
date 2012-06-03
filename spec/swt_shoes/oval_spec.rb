require 'swt_shoes/spec_helper'

describe Shoes::Swt::Oval do
  let(:gui_container) { double("gui container") }
  let(:opts) { {:container => gui_container} }
  let(:fill) { Shoes::COLORS[:papayawhip] }
  let(:stroke) { Shoes::COLORS[:honeydew] }
  let(:style) { {:strokewidth => 3} }
  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:dsl) { 
    double("dsl object", 
      :fill => fill,
      :stroke => stroke,
      :style => style,
      :left => left,
      :top => top,
      :width => width,
      :height => height).as_null_object
                      
            }

  subject {
    Shoes::Swt::Oval.new(dsl, opts)
  }

  it_behaves_like "paintable"
  it_behaves_like "Swt object with stroke"
  it_behaves_like "Swt object with fill"

  describe "paint callback" do
    let(:event) { double("event") }
    let(:gc) { double("gc").as_null_object }

    before :each do
      event.stub(:gc) { gc }
      gui_container.should_receive(:add_paint_listener)
    end

    specify "fills oval" do
      gc.should_receive(:fill_oval).with(left, top, width, height)
      subject.paint_callback.call(event)
    end

    specify "draws oval" do
      gc.should_receive(:draw_oval).with(left, top, width, height)
      subject.paint_callback.call(event)
    end
  end
end

