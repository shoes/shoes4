require 'shoes/spec_helper'

describe Shoes::TextBlockDimensions do
  let(:old_dimension) { Shoes::Dimensions.new(nil, 0, 10, 5, 10) }
  subject             { Shoes::TextBlockDimensions.new(nil, 0, 10, 5, 10) }

  before(:each) do
    old_dimension.absolute_left = subject.absolute_left = 0
    old_dimension.absolute_top  = subject.absolute_top  = 0
  end

  context "positions" do
    it "inherits from base" do
      expect(subject.absolute_right).to eq(old_dimension.absolute_right)
      expect(subject.absolute_bottom).to eq(old_dimension.absolute_bottom)
    end

    it "overrides absolute right" do
      subject.absolute_right = 200
      expect(subject.absolute_right).to eq(200)
    end

    it "overrides absolute bottom" do
      subject.absolute_bottom = 200
      expect(subject.absolute_bottom).to eq(200)
    end
  end

  context "calculated sizes" do
    it "inherits from base" do
      expect(subject.width).to  eq(5)
      expect(subject.height).to eq(10)
    end

    it "override with calculated width" do
      subject.width = nil
      subject.calculated_width = 200
      expect(subject.width).to eq(200)
    end

    it "override with calculated height" do
      subject.height = nil
      subject.calculated_height = 200
      expect(subject.height).to eq(200)
    end
  end
end
