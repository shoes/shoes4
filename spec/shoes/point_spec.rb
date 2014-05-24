require 'shoes/spec_helper'

describe Shoes::Point do
  subject { Shoes::Point.new(40, 50) }
  let(:other_point) { Shoes::Point.new(10, 60) }

  its(:x) { should eq(40) }
  its(:y) { should eq(50) }

  specify "#left works on either point" do
    subject.left(other_point).should eq(10)
    other_point.left(subject).should eq(10)
  end

  specify "#top works on either point" do
    subject.top(other_point).should eq(50)
    other_point.top(subject).should eq(50)
  end

  describe "equality" do
    specify "requires x and y to be equal" do
      subject.should eq(Shoes::Point.new 40, 50)
      subject.should_not eq(Shoes::Point.new 41, 50)
      subject.should_not eq(Shoes::Point.new 40, 51)
    end

    specify "works with other (x,y) objects" do
      subject.should eq(Struct.new(:x, :y).new(40, 50))
    end
  end

  describe "#to" do
    specify "positive" do
      subject.to(24, 166).should eq(Shoes::Point.new(64, 216))
    end

    specify "negative" do
      subject.to(-24, -166).should eq(Shoes::Point.new(16, -116))
    end
  end

  specify "calculates width of rectangle created with other point" do
    subject.width(other_point).should eq(30)
    other_point.width(subject).should eq(30)
  end

  specify "calculates height of rectangle created with other point" do
    subject.height(other_point).should eq(10)
    other_point.height(subject).should eq(10)
  end
end
