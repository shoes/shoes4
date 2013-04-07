require "shoes/spec_helper"

# Since testing all ways of calling these methods can get a bit elaborate, you
# can split of a file for each method. See element_methods/edit_box_spec.rb for
# an example
describe Shoes::ElementMethods do
  describe "color(c)" do
    it "should conform to the manual"
  end

  describe "pattern(*args)" do
    it "should conform to the manual"
  end

  describe "pop_and_normalize_style(opts)" do
    it "should conform to the manual"
  end

  describe "normalize_style(orig_style)" do
    it "should conform to the manual"
  end

  describe "image(path, opts={}, &blk)" do
    it "should conform to the manual"
  end

  describe "border(color, opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "background(color, opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "edit_line(opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "progress(opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "check(opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "radio(opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "list_box(opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "flow(opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "stack(opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "button(text, opts={}, &blk)" do
    it "should conform to the manual"
  end

  describe "animate(opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "every n=1, &blk" do
    it "should conform to the manual"
  end

  describe "timer n=1, &blk" do
    it "should conform to the manual"
  end

  describe "sound(soundfile, opts = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "arc(left, top, width, height, angle1, angle2, opts = {})" do
    it "should conform to the manual"
  end

  describe "line(x1, y1, x2, y2, opts = {})" do
    it "should conform to the manual"
  end

  describe "oval(*opts, &blk)" do
    it "should conform to the manual"
  end

  describe "rect(*args, &blk)" do
    it "should conform to the manual"
  end

  describe "star(*args, &blk)" do
    it "should conform to the manual"
  end

  describe "shape(shape_style = {}, &blk)" do
    it "should conform to the manual"
  end

  describe "rgb(red, green, blue, alpha = Shoes::Color::OPAQUE)" do
    it "should conform to the manual"
  end

  describe "gradient(*args)" do
    it "should conform to the manual"
  end

  describe "image_pattern path" do
    it "should conform to the manual"
  end

  describe "stroke(color)" do
    it "should conform to the manual"
  end

  describe "nostroke" do
    it "should conform to the manual"
  end

  describe "strokewidth(width)" do
    it "should conform to the manual"
  end

  describe "fill(pattern)" do
    it "should conform to the manual"
  end

  describe "nofill" do
    it "should conform to the manual"
  end

  describe "cap line_cap" do
    it "should conform to the manual"
  end

  describe "style(new_styles = {})" do
    it "should conform to the manual"
  end

  %w[banner title subtitle tagline caption para inscription].each do |method|
    describe method do
      it "should conform to the manual"
    end
  end

  describe "get_styles msg, styles=[], spoint=0" do
    it "should conform to the manual"
  end

  %w[code del em ins strong sub sup].each do |method|
    describe method  do
      it "should conform to the manual"
    end
  end

  %w[bg fg].each do |method|
    describe method  do
      it "should conform to the manual"
    end
  end

  describe "link *str, &blk" do
    it "should conform to the manual"
  end

  describe "mouse" do
    it "should conform to the manual"
  end

  describe "motion &blk" do
    it "should conform to the manual"
  end

  describe "keypress &blk" do
    it "should conform to the manual"
  end

  describe "clear" do
    it "should conform to the manual"
  end

  describe "visit url" do
    it "should conform to the manual"
  end

  describe "scroll_top" do
    it "should conform to the manual"
  end

  describe "scroll_top=(n)" do
    it "should conform to the manual"
  end

  describe "clipboard" do
    it "should conform to the manual"
  end

  describe "clipboard=(str)" do
    it "should conform to the manual"
  end
end
