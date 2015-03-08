require 'shoes/spec_helper'

describe Shoes::Line do
  include_context "dsl app"

  describe "basic" do
    let(:left) { 20 }
    let(:top) { 23 }
    let(:width) { 280 }
    let(:height) { 407 }

    subject { Shoes::Line.new(app, parent, Shoes::Point.new(left, top), Shoes::Point.new(300, 430), input_opts) }
    it_behaves_like "movable object"
    it_behaves_like "object with style" do
      let(:subject_without_style) { Shoes::Line.new(app, parent, Shoes::Point.new(left, top), Shoes::Point.new(300, 430)) }
      let(:subject_with_style) { Shoes::Line.new(app, parent, Shoes::Point.new(left, top), Shoes::Point.new(300, 430), arg_styles) }
    end
    it_behaves_like "object with dimensions"
    it_behaves_like 'object with parent'
  end

  describe "line with point a at leftmost, topmost" do
    subject { Shoes::Line.new(app, app, Shoes::Point.new(10, 15), Shoes::Point.new(100, 60), input_opts) }
    its(:left)   { should eq(10) }
    its(:top)    { should eq(15) }
    its(:right)  { should eq(100) }
    its(:bottom) { should eq(60) }
    its(:width)  { should eq(90) }
    its(:height) { should eq(45) }
  end

  describe "specified right-to-left, top-to-bottom" do
    subject { Shoes::Line.new(app, app, Shoes::Point.new(100, 60), Shoes::Point.new(10, 15), input_opts) }
    its(:left)   { should eq(100) }
    its(:top)    { should eq(60) }
    its(:right)  { should eq(10) }
    its(:bottom) { should eq(15) }
    its(:width)  { should eq(-90) }
    its(:height) { should eq(-45) }
  end

  describe "setting dimensions" do
    subject { Shoes::Line.new(app, app, Shoes::Point.new(100, 100), Shoes::Point.new(200, 200), input_opts) }

    it "moves point a with left and top" do
      subject.left -= 100
      subject.top  -= 100
      expect(subject.point_a).to eq(Shoes::Point.new(0, 0))
    end

    it "moves point a even when it's not leftmost or topmost" do
      2.times do
        subject.left += 100
        subject.top += 100
      end

      expect(subject.point_a).to eq(Shoes::Point.new(300, 300))
    end

    it "moves point a with right and bottom" do
      subject.right  += 100
      subject.bottom += 100
      expect(subject.point_b).to eq(Shoes::Point.new(300, 300))
    end

    it "moves point b even when it's not rightmost or bottommost" do
      2.times do
        subject.right  -= 100
        subject.bottom -= 100
      end

      expect(subject.point_b).to eq(Shoes::Point.new(0, 0))
    end

    it "can move point a" do
      subject.move(10, 10)
      expect(subject.point_a).to eq(Shoes::Point.new(10, 10))
      expect(subject.point_b).to eq(Shoes::Point.new(200, 200))
    end

    it "can move all points" do
      subject.move(10, 10, 20, 20)
      expect(subject.point_a).to eq(Shoes::Point.new(10, 10))
      expect(subject.point_b).to eq(Shoes::Point.new(20, 20))
    end
  end

  describe "#in_bounds?" do
    subject(:line) { Shoes::Line.new(app, app, Shoes::Point.new(100, 100), Shoes::Point.new(50, 50), input_opts) }

    it "returns true if a point is in the end of the line" do
      expect(subject.in_bounds?(100, 100)).to be true
    end

    it "returns true if a point is in the end of the line" do
      expect(subject.in_bounds?(50, 50)).to be true
    end

    it "returns true if a point is in the middle of the line" do
      expect(subject.in_bounds?(75, 75)).to be true
    end

    it "returns false if a point is not in the line" do
      expect(subject.in_bounds?(201, 200)).to be false
    end

    it "takes into account :strokewidth style" do
      line = Shoes::Line.new(app, app, Shoes::Point.new(50, 50), Shoes::Point.new(70, 50), input_opts) 
      line.style(strokewidth: 20)
      expect(line.in_bounds?(50, 52)).to be true
      expect(line.in_bounds?(50, 48)).to be true
      expect(line.in_bounds?(50, 60)).to be true
      expect(line.in_bounds?(50, 40)).to be true
      expect(line.in_bounds?(49, 50)).to be false
      expect(line.in_bounds?(50, 61)).to be false
      expect(line.in_bounds?(70, 50)).to be true
    end
  end
end
