require 'swt_shoes/spec_helper'

describe Shoes::Swt::LinkSegment do
  let(:range)         { (2..10) }
  let(:width)         { 20 }
  let(:height)        { 14 }
  let(:layout)        { double('swt layout', width: width, line_count: 10) }
  let(:fitted_layout) { double('fitted layout', layout: layout,
                               element_left: 0, element_top: 0) }

  subject { Shoes::Swt::LinkSegment.new(fitted_layout, range) }

  before(:each) do
    10.times {|i| stub_line_bounds(i)}
  end

  # xxxxxxxxxx..........
  it "sets bounds on single line" do
    stub_start_and_end_locations([0, 0], [10, 0])

    expect_bounded_box(0, 0, 10, 14)
  end

  # xxxxxxxxxxxxxxxxxxxx
  # xxxxx...............
  it "sets bounds wrapping to second line" do
    stub_start_and_end_locations([0, 0], [5, 14])

    expect_bounded_box(0, 0, 20, 14)
    expect_bounded_box(0, 14, 5, 28)
  end

  # .....xxxxxxxxxxxxxxx
  # xxxxxxxxxxxxxxxxxxxx
  # xxxxx...............
  it "sets bounds wrapping over three lines" do
    stub_start_and_end_locations([5, 0], [5, 28])

    expect_bounded_box(5, 0,  20, 14)
    expect_bounded_box(0, 14, 20, 28)
    expect_bounded_box(0, 28, 5,  42)
  end

  # ....................
  # .....xxxxxxxxxx.....
  it "sets bounds with single line beginning further down" do
    stub_start_and_end_locations([5, 14], [15, 14])

    expect_bounded_box(5, 14, 15, 28)
  end

  # ....................
  # ...............xxxxx
  # xxxxx...............
  it "sets bounds with two lines beginning further down" do
    stub_start_and_end_locations([15, 14], [5, 28])

    expect_bounded_box(15, 14, 15, 28)
    expect_bounded_box(0,  28, 5,  42)
  end

  # ....................
  # ...............xxxxx
  # xxxxxxxxxxxxxxxxxxxx
  # xxxxx...............
  it "sets bounds with three lines beginning further down" do
    stub_start_and_end_locations([15, 14], [5, 42])

    expect_bounded_box(15, 14, 15, 28)
    expect_bounded_box(0,  28, 20, 42)
    expect_bounded_box(0,  42, 5,  56)
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

  def stub_start_and_end_locations(first, last)
    stub_location(range.first, first[0], first[1])
    stub_location(range.last, last[0], last[1])
  end

  def stub_location(at, x, y)
    fitted_layout.stub(:get_location).with(at, anything) { double(x: x, y: y) }
  end

  def stub_line_bounds(index)
    layout.stub(:line_bounds).with(index) {
      double("line #{index}",
             x: 0, y: index * height,
             width: width, height: height)
    }
  end
end
