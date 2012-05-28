require 'shoes/spec_helper'

describe Shoes::Oval do
  describe "basic" do
    subject { Shoes::Oval.new(20, 30, 100, 200) }
    it_behaves_like "object with stroke"
    it_behaves_like "object with fill"
    it_behaves_like "movable object"
  end

  context "(eccentric)" do
    subject { Shoes::Oval.new(20, 30, 100, 200) }

    it { should be_instance_of(Shoes::Oval) }
    its (:top) { should eq(30) }
    its (:left) { should eq(20) }
    its (:width) { should eq(100) }
    its (:height) { should eq(200) }
  end

  shared_examples_for "circle" do
    it { should be_instance_of(Shoes::Oval) }
    its (:top) { should eq(30) }
    its (:left) { should eq(20) }
    its (:width) { should eq(100) }
    its (:height) { should eq(100) }
  end

  context "(circle) created with explicit arguments:" do
    context "width and height" do
      subject { Shoes::Oval.new(20, 30, 100, 100) }
      it_behaves_like "circle"
    end

    context "radius" do
      subject { Shoes::Oval.new(20, 30, 50) }
      it_behaves_like "circle"
    end
  end

  context "(circle) created with style hash:" do
    context "left, top, height, width" do
      subject { Shoes::Oval.new(left: 20, top: 30, width: 100, height: 100) }
      it_behaves_like "circle"
    end

    context "left, top, height, width, center: false" do
      subject { Shoes::Oval.new(left: 20, top: 30, width: 100, height: 100, center: false) }
      it_behaves_like "circle"
    end

    context "left, top, radius" do
      subject { Shoes::Oval.new(left: 20, top: 30, radius: 50) }
      it_behaves_like "circle"
    end

    context "left, top, width, height, center: true" do
      subject { Shoes::Oval.new(left: 70, top: 80, width: 100, height: 100, center: true) }
      it_behaves_like "circle"
    end
  end
end
