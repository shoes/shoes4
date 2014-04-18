require 'swt_shoes/spec_helper'

describe Shoes::Swt::LinkSegment do
  let(:range)         { (2..10) }
  let(:width)         { 20 }
  let(:height)        { 14 }
  let(:layout)        { double('swt layout', width: width,
                               get_line_bounds: double('bounds', height: height)) }
  let(:fitted_layout) { double('fitted layout', layout: layout,
                               element_left: 0, element_top: 0) }

  subject { Shoes::Swt::LinkSegment.new(fitted_layout, range) }

  # xxxxxxxxxx..........
  it "sets bounds on single line" do
    layout.stub(:line_count) { 1 }
    fitted_layout.stub(:get_location).with(2, false) { double(x: 0, y: 0) }
    fitted_layout.stub(:get_location).with(10, true) { double(x: 10, y: 0) }

    expect(subject.in_bounds?(0,0)).to eql(true)
    expect_bounded_box(0, 0, 10, 14)
    expect_out_of_bounds([0,15], [11,0], [10,15])
  end

  # xxxxxxxxxxxxxxxxxxxx
  # xxxxx...............
  it "sets bounds wrapping to second line" do
    layout.stub(:line_count) { 2 }
    fitted_layout.stub(:get_location).with(2, false) { double(x: 0, y: 0) }
    fitted_layout.stub(:get_location).with(10, true) { double(x: 5, y: 14) }

    expect_bounded_box(0, 0, 20, 14)
    expect_bounded_box(0, 14, 5, 28)
    expect_out_of_bounds([0, 29], [21, 0], [21,14], [6,15], [6,28])
  end

  # .....xxxxxxxxxxxxxxx
  # xxxxxxxxxxxxxxxxxxxx
  # xxxxx...............
  it "sets bounds wrapping over three lines" do
    layout.stub(:line_count) { 3 }
    fitted_layout.stub(:get_location).with(2, false) { double(x: 5, y: 0) }
    fitted_layout.stub(:get_location).with(10, true) { double(x: 5, y: 28) }

    expect_bounded_box(5, 0,  20, 14)
    expect_bounded_box(0, 14, 20, 28)
    expect_bounded_box(0, 28, 5,  42)
  end

  def expect_bounded_box(left, top, right, bottom)
    expect_in_bounds([left, top],    [right, top],
                     [left, bottom], [right,bottom])
  end

  def expect_in_bounds(*points)
    points.each do |(x,y)|
      expect(subject.in_bounds?(x, y)).to be_true, "with #{x}, #{y}"
    end
  end

  def expect_out_of_bounds(*points)
    points.each do |(x,y)|
      expect(subject.in_bounds?(x, y)).to be_false, "with #{x}, #{y}"
    end
  end
end
