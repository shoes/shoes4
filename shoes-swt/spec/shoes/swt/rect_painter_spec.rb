# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Swt::RectPainter do
  include_context "swt app"
  include_context "painter context"

  let(:corners) { 0 }
  let(:app) { double('app', real: container, add_paint_listener: true, dsl: dsl) }
  let(:container) { double('container', disposed?: false) }

  let(:dsl) do
    double("dsl object", parent: parent, hidden: false, rotate: 0,
                         translate_left: 0, translate_top: 0,
                         element_left: left, element_top: top,
                         element_width: width, element_height: height,
                         curve: corners, style: {}, strokewidth: 1).as_null_object
  end

  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }
  let(:shape) { Shoes::Swt::Rect.new dsl, app }
  subject { Shoes::Swt::RectPainter.new shape }

  it_behaves_like "fill painter"
  it_behaves_like "stroke painter"

  describe "square corners" do
    let(:corners) { 0 }

    it "fills rect" do
      expect(gc).to receive(:fill_round_rectangle).with(left, top, width, height, corners * 2, corners * 2)
      subject.paint_control(event)
    end

    it "draws rect" do
      expect(gc).to receive(:draw_round_rectangle).with(left + sw / 2, top + sw / 2, width - sw, height - sw, corners * 2, corners * 2)
      subject.paint_control(event)
    end
  end

  describe "round corners" do
    let(:corners) { 13 }

    it "draws rect with rounded corners" do
      expect(gc).to receive(:draw_round_rectangle).with(left + sw / 2, top + sw / 2, width - sw, height - sw, corners * 2, corners * 2)
      subject.paint_control(event)
    end
  end

  describe "scrolling" do
    it "draws rect offset" do
      allow(parent).to receive(:scroll_top).and_return(10)
      expect(gc).to receive(:draw_round_rectangle).with(left + sw / 2, top - 10 + sw / 2, width - sw, height - sw, corners * 2, corners * 2)
      subject.paint_control(event)
    end
  end
end
