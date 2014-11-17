require 'shoes/spec_helper'

describe Shoes::TextBlockDimensions do
  let(:left)   { 0 }
  let(:top)    { 10 }
  let(:width)  { 5 }
  let(:height) { 10 }

  let(:old_dimension) { Shoes::Dimensions.new(nil, left, top, width, height) }
  subject             { Shoes::TextBlockDimensions.new(nil, left, top, width, height) }

  before(:each) do
    old_dimension.absolute_left = subject.absolute_left = 0
    old_dimension.absolute_top  = subject.absolute_top  = 0
  end

  describe "positions" do
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

  describe "calculated sizes" do
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

  describe "containing width" do
    it "uses immediate width if it can" do
      expect(subject.containing_width).to eq(5)
    end

    it "applies margins" do
      subject.margin = 1
      expect(subject.containing_width).to eq(3)
    end

    describe "with parent" do
      let(:parent) { double('parent', element_width: 100,
                            x_dimension: double("x"),
                            y_dimension: double("y")) }
      subject { Shoes::TextBlockDimensions.new(parent, left, top, nil, height) }

      it "delegates to parent if no width of its own" do
        expect(subject.containing_width).to eq(100)
      end
    end

  end
end
