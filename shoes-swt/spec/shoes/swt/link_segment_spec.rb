require 'shoes/swt/spec_helper'

describe Shoes::Swt::LinkSegment do
  let(:range)         { (2..10) }
  let(:line_width)    { 20 }
  let(:line_height)   { 14 }
  let(:layout)        { double('swt layout', width: line_width, line_count: 10) }
  let(:text_segment)  { double('text segment', layout: layout,
                               element_left: 0, element_top: 0) }

  subject { Shoes::Swt::LinkSegment.new(text_segment, range) }

  before(:each) do
    10.times {|i| stub_line_bounds(i)}
  end


  # ....................
  context "empty link" do
    let(:range) { (0...0) }

    it "fails all bounds checks" do
      stub_start_and_end_locations([0, 0], [10, 0])
      expect_not_in_bounds(0, 0, 10, line_height)
    end
  end

  # xxxxxxxxxx..........
  it "sets bounds on single line" do
    stub_start_and_end_locations([0, 0], [10, 0])

    expect_bounded_box(0, 0, 10, line_height)
  end

  # xxxxxxxxxxxxxxxxxxxx
  # xxxxx...............
  it "sets bounds wrapping to second line" do
    stub_start_and_end_locations([0, 0], [5, line_height])

    expect_bounded_box(0, 0,           line_width, line_height)
    expect_bounded_box(0, line_height, 5,          2*line_height)
  end

  # .....xxxxxxxxxxxxxxx
  # xxxxxxxxxxxxxxxxxxxx
  # xxxxx...............
  it "sets bounds wrapping over three lines" do
    stub_start_and_end_locations([5, 0], [5, 2*line_height])

    expect_bounded_box(5, 0,             line_width, line_height)
    expect_bounded_box(0, line_height,   line_width, 2*line_height)
    expect_bounded_box(0, 2*line_height, 5,          3*line_height)
  end

  # ....................
  # .....xxxxxxxxxx.....
  it "sets bounds with single line beginning further down" do
    stub_start_and_end_locations([5, line_height], [15, line_height])

    expect_bounded_box(5, line_height, 15, 2*line_height)
  end

  # ....................
  # ...............xxxxx
  # xxxxx...............
  it "sets bounds with two lines beginning further down" do
    stub_start_and_end_locations([15, line_height], [5, 2*line_height])

    expect_bounded_box(15, line_height,   15, 2*line_height)
    expect_bounded_box(0,  2*line_height, 5,  3*line_height)
  end

  # ....................
  # ...............xxxxx
  # xxxxxxxxxxxxxxxxxxxx
  # xxxxx...............
  it "sets bounds with three lines beginning further down" do
    stub_start_and_end_locations([15, line_height], [5, 3*line_height])

    expect_bounded_box(15, line_height,   15,         2*line_height)
    expect_bounded_box(0,  2*line_height, line_width, 3*line_height)
    expect_bounded_box(0,  3*line_height, 5,          4*line_height)
  end

  def expect_bounded_box(left, top, right, bottom)
    expect_in_bounds([left, top],    [right, top],
                     [left, bottom], [right,bottom])
  end

  def expect_in_bounds(*points)
    points.each do |(x,y)|
      expect(subject.in_bounds?(x, y)).to be_truthy, "with #{x}, #{y}"
    end
  end

  def expect_not_in_bounds(*points)
    points.each do |(x,y)|
      expect(subject.in_bounds?(x, y)).to be_falsey, "with #{x}, #{y}"
    end
  end

  def stub_start_and_end_locations(first, last)
    stub_location(range.first, first[0], first[1])
    stub_location(range.last, last[0], last[1])
  end

  def stub_location(at, x, y)
    allow(text_segment).to receive(:get_location).with(at, anything) { double(x: x, y: y) }
  end

  def stub_line_bounds(index)
    allow(layout).to receive(:line_bounds).with(index) {
      double("line #{index}",
             x: 0,
             y: index * line_height,
             width: line_width,
             height: line_height)
    }
  end
end
