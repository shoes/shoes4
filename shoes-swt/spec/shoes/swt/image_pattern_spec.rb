# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Swt::ImagePattern do
  let(:dsl)         { Shoes::ImagePattern.new("some/path/to") }
  let(:applied_to)  { double("applied to", width: 100, height: 100,
                             element_left: 0, element_top: 0,
                             element_right: 100, element_bottom: 100) }

  let(:swt_image)   { double("swt image", bounds: bounds) }
  let(:bounds)      { double("bounds", width: 100, height: 100) }
  let(:gc)          { double("gc", draw_image: nil) }

  subject { Shoes::Swt::ImagePattern.new(dsl) }

  before do
    allow(::Swt::Image).to receive(:new) { swt_image }
  end

  describe "#dispose" do
    it "disposes of sub-resources" do
      expect(swt_image).to receive(:dispose)
      subject.apply_as_fill(gc, applied_to)
      subject.dispose
    end
  end

  describe "#apply_as_stroke" do
    it "draws" do
      expect(gc).to receive(:draw_image)
      subject.apply_as_stroke(gc, applied_to)
    end
  end

  describe "#apply_as_fill" do
    it "draws" do
      expect(gc).to receive(:draw_image)
      subject.apply_as_fill(gc, applied_to)
    end
  end

  describe "#draw_image_pattern" do
    let(:partial) { 20 }
    let(:full)    { 100 }

    it "draws once if too small" do
      allow(applied_to).to receive(:width)  { 10 }
      allow(applied_to).to receive(:height) { 10 }

      expect_drawn(0, 0)
      subject.draw_image_pattern(gc, applied_to)
    end

    it "draws partial horizontally" do
      allow(applied_to).to receive(:width)         { full + partial }
      allow(applied_to).to receive(:element_right) { full + partial }

      expect_drawn(0, 0,   width: full)
      expect_drawn(100, 0, width: partial)
      subject.draw_image_pattern(gc, applied_to)
    end

    it "draws partial vertically" do
      allow(applied_to).to receive(:height)         { full + partial }
      allow(applied_to).to receive(:element_bottom) { full + partial }

      expect_drawn(0, 0,   height: full)
      expect_drawn(0, 100, height: partial)
      subject.draw_image_pattern(gc, applied_to)
    end

    def expect_drawn(left, top, opts={})
      width  = opts[:width] || 100
      height = opts[:height] || 100

      expect(gc).to receive(:draw_image).with(swt_image, 0, 0,
                                              width, height,
                                              left, top,
                                              width, height)
    end
  end
end
