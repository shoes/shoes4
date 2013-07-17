require 'swt_shoes/spec_helper'

describe Shoes::Swt::RectPainter do
  include_context "painter context"

  let(:corners) { 0 }
  let(:app) { double('app', :real => container, :add_paint_listener => true, :dsl => dsl) }
  let(:container) { double('container', :disposed? => false) }
  let(:dsl) { double("dsl object", hidden: false, rotate: 0).as_null_object }
  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }
  let(:shape) { Shoes::Swt::Rect.new dsl, app, left, top, width, height, :curve => corners }
  subject { Shoes::Swt::RectPainter.new shape }

  it_behaves_like "fill painter"
  it_behaves_like "stroke painter"

  describe "square corners" do
    let(:corners) { 0 }

    it "fills rect" do
      gc.should_receive(:fill_round_rectangle).with(left, top, width, height, corners*2, corners*2)
      subject.paint_control(event)
    end

    it "draws rect" do
      gc.should_receive(:draw_round_rectangle).with(left+sw/2, top+sw/2, width-sw, height-sw, corners*2, corners*2)
      subject.paint_control(event)
    end
  end

  describe "round corners" do
    let(:corners) { 13 }

    it "draws rect with rounded corners" do
      gc.should_receive(:draw_round_rectangle).with(left+sw/2, top+sw/2, width-sw, height-sw, corners*2, corners*2)
      subject.paint_control(event)
    end
  end
end