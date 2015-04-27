require 'shoes/swt/spec_helper'

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
end
