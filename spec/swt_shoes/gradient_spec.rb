require 'swt_shoes/spec_helper'

describe Shoes::Swt::Gradient do
  let(:color1) { Shoes::Color.create(Shoes::COLORS[:honeydew]) }
  let(:color2) { Shoes::Color.create(Shoes::COLORS[:salmon]) }
  let(:dsl) { Shoes::Gradient.new(color1, color2) }
  let(:gc) { double("gc", set_background_pattern: nil) }

  subject { Shoes::Swt::Gradient.new(dsl) }

  it_behaves_like "an swt pattern"

  describe "#dispose" do
    it "lets subresources do" do
      # Prime the object's lazy colors
      subject.apply_as_fill(gc, 10, 20, 100, 200)

      expect(subject.color1).to receive(:dispose)
      expect(subject.color2).to receive(:dispose)

      subject.dispose
    end
  end

  describe "#apply_as_fill" do
    it "sets background" do
      expect(gc).to receive(:set_background_pattern)
      subject.apply_as_fill(gc, 10, 20, 100, 200)
    end
  end

  describe "comparable" do
    let(:new_color) { Shoes::Color.create(Shoes::COLORS[:limegreen]) }

    it "is equal when values are equal" do
      gradient_2 = Shoes::Gradient.new(color1, color2)
      expect(subject).to eq(gradient_2)
    end

    it "is not equal when color 1 is different" do
      gradient_2 = Shoes::Gradient.new(new_color, color2)
      expect(subject).to not_eq(gradient_2)
    end

    it "is not equal when color 2 is different" do
      gradient_2 = Shoes::Gradient.new(new_color, color2)
      expect(subject).to not_eq(gradient_2)
    end

    it "is not equal to just a color" do
      gradient_2 = Shoes::Gradient.new(color1, new_color)
      expect(subject).to not_eq(gradient_2)
    end

  end
end
