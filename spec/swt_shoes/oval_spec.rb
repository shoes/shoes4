require 'swt_shoes/spec_helper'

describe Shoes::Swt::Oval do
  let(:app) { double('app', real: true) }
  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:dsl) { double("dsl object").as_null_object }

  subject {
    Shoes::Swt::Oval.new(dsl, app, left, top, width, height)
  }

  it_behaves_like "paintable"

  describe "painter" do
    include_context "painter context"

    subject { Shoes::Swt::Oval::Painter.new(shape) }

    it_behaves_like "fill painter"
    it_behaves_like "stroke painter"

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

