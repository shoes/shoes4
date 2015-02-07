require 'shoes/swt/spec_helper'

describe Shoes::Swt::TextBlock::TextSegment do
  let(:layout) { double("layout", text: "the text",
                        :alignment= => nil, :justify= => nil, :spacing= => nil,
                        :text= => nil, :width= => nil,
                        disposed?: false, dispose: nil,
                        set_style: nil, bounds: bounds) }
  let(:bounds) { Java::OrgEclipseSwtGraphics::Rectangle.new(0, 0, 0, 0) }
  let(:element_left) { 0 }
  let(:element_top)  { 0 }
  let(:segment_width)  { 10 }
  let(:segment_height) { 10 }
  let(:left_offset)   { 5 }
  let(:top_offset)    { 5 }

  let(:font_factory) { double("font factory", create_font: font, dispose: nil) }
  let(:style_factory) { double("style factory", create_style: style, dispose: nil) }
  let(:font)   { double("font") }
  let(:style)  { double("style") }

  let(:style_hash) {
    {
      bg: double("bg"),
      fg: double("fg"),
      font_detail: {
        name: "Comic Sans",
        size: 18,
        styles: nil
      }
    }
  }

  let(:dsl) { double("dsl", font: "", size: 16, style:{}) }

  before(:each) do
    allow(::Swt::TextLayout).to receive(:new)            { layout }
    allow(Shoes::Swt::TextFontFactory).to receive(:new)  { font_factory }
    allow(Shoes::Swt::TextStyleFactory).to receive(:new) { style_factory }
  end

  subject do
    segment = Shoes::Swt::TextBlock::TextSegment.new(dsl, "text", segment_width)
    segment.position_at(element_left, element_top)
  end

  context "disposal" do
    it "disposes of underlying layout" do
      allow(layout).to receive(:disposed?) { false }
      expect(layout).to receive(:dispose)
      subject.dispose
    end

    it "doesn't overdispose" do
      allow(layout).to receive(:disposed?) { true }
      expect(layout).to_not receive(:dispose)
      subject.dispose
    end
  end

  context "setting style" do
    it "on full range" do
      subject.set_style(style_hash)
      expect(layout).to have_received(:set_style).
                          with(style, 0, layout.text.length - 1).
                          at_least(1).times
    end

    it "with a range" do
      subject.set_style(style_hash, 1..2)
      expect(layout).to have_received(:set_style).with(style, 1, 2)
    end

    it "ignores empty ranges" do
      subject.set_style(style_hash, 0...0)
      expect(layout).to_not have_received(:set_style).with(style, 0, 0)
    end
  end

  describe "shrinking on initialization" do
    it "happens when too long for container" do
      bounds.width = segment_width + 10
      expect(subject.layout).to have_received(:width=).with(segment_width)
    end

    it "happens even when enough containing width" do
      expect(subject.layout).to have_received(:width=).with(segment_width)
    end
  end

  context "bounds checking" do
    before(:each) do
      set_bounds(0, 0, segment_width, segment_height)
    end

    it "checks boundaries" do
      expect(subject.in_bounds?(1,1)).to be_truthy
    end

    describe "offsets left" do
      let(:element_left) { left_offset }

      it "checks boundaries" do
        expect(subject.in_bounds?(segment_width + left_offset - 1, 0)).to be_truthy
      end
    end

    describe "offsets top" do
      let(:element_top) { top_offset }

      it "checks boundaries" do
        expect(subject.in_bounds?(0, segment_height + top_offset - 1)).to be_truthy
      end
    end

    def set_bounds(x, y, width, height)
      bounds.x = x
      bounds.y = y
      bounds.width = width
      bounds.height = height
    end
  end

  describe "dispose" do
    it "should dispose its Swt fonts" do
      subject.dispose
      expect(font_factory).to have_received(:dispose)
    end

    it "should dispose its Swt colors" do
      subject.dispose
      expect(style_factory).to have_received(:dispose)
    end
  end
end
