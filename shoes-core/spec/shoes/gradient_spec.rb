require 'shoes/spec_helper'

describe Shoes::Gradient do
  let(:color1) { Shoes::COLORS[:honeydew] }
  let(:color2) { Shoes::COLORS[:salmon] }
  subject { Shoes::Gradient.new(color1, color2) }

  describe "comparable" do
    let(:new_color) { Shoes::COLORS[:limegreen] }

    it "is equal when values are equal" do
      gradient_2 = Shoes::Gradient.new(color1, color2)
      expect(subject).to eq(gradient_2)
    end

    it "is not equal when color 1 is different" do
      gradient_2 = Shoes::Gradient.new(new_color, color2)
      expect(subject).not_to eq(gradient_2)
    end

    it "is not equal when color 2 is different" do
      gradient_2 = Shoes::Gradient.new(new_color, color2)
      expect(subject).not_to eq(gradient_2)
    end

    it "is not equal to just a color" do
      gradient_2 = Shoes::Gradient.new(color1, new_color)
      expect(subject).not_to eq(gradient_2)
    end

  end
end
