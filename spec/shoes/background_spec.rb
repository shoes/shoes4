require 'shoes/spec_helper'

describe Shoes::Background do
  let(:app_width) { 400 }
  let(:app_height) { 200 }
  let(:white) { Shoes::COLORS[:white] }
  let(:blue)  { Shoes::COLORS[:blue] }
  let(:paint_event) do
    paint_event = double "paint_event"
    paint_event.stub(height: app_height, width: app_width)
    paint_event
  end
  let(:input_block) { Proc.new {} }
  let(:input_opts) { { height: 30 } }
  let(:parent) { double("parent").as_null_object }
  subject { Shoes::Background.new(parent, blue,
                                  input_opts, input_block) }

  it { should respond_to :fill }

  it "should set the color" do
    subject.color.should eql blue
  end

  describe "set_width" do
    it "sets the width to options[:width] if supplied" do
      test_set_width(50, width: 50)
    end

    it "sets the width to twice the radius if supplied" do
      test_set_width(2*25, radius: 25)
    end

    it "sets the width to the width option even if radius is supplied" do
      test_set_width(50, width: 50, radius: 70)
    end

    it "sets the width correctly if right and left are supplied" do
      # the purpose is that left and right are the offsets from the borders
      # the method then computes the distance between those 2 offsets
      test_set_width(app_width - (30 + 20), left: 20, right: 30)
    end

    it "doest not use left and right if width is also supplied" do
      test_set_width(70, left: 20, right: 30, width: 70)
    end

    it "sets the width to the app width if no width parameters are supplied" do
      test_set_width(app_width, {})
    end
  end


  describe "set_height" do
    it "sets height to height if supplied" do
      test_set_height(50, height: 50)
    end

    it "sets height to twice the radius if supplied" do
      test_set_height(2 * 40, radius: 40)
    end

    it "sets height corectly if bottom and top are supplied" do
      test_set_height(app_height - ( 30 + 50), bottom: 30, top: 50)
    end

    it "doesn't use bottom and top if heifht is specified" do
      test_set_height(150, bottom: 30, top: 25, height: 150)
    end

    it "Sets height to the app height if no options are supplied" do
      test_set_height(app_height, {})
    end

  end

  describe "set_x" do
    it "sets x to :left if supplied" do
      test_set_x(25, left: 25)
    end

    it "sets x to 0 when just right is supplied" do
      test_set_x(0, right: 70)
    end

    it "sets x accordingly if right and width are supplied" do
      test_set_x(app_width - (50 + 30), width: 50, right: 30)
    end

    it "sets x to 0 if nothing is supplied" do
      test_set_x(0, {})
    end
  end

  describe "set_y" do
    it "sets y to :top if supplied" do
      test_set_y(35, top: 35)
    end

    it "sets y to 0 when just :bottom is supplied" do
      test_set_y(0, bottom: 55)
    end

    it "sets y accordingly if bottom and height are supplied" do
      test_set_y(app_height - (75 + 100), height: 75, bottom: 100)
    end

    it "sets y to 0 if nothing is supplied" do
      test_set_y(0, {})
    end
  end


  describe "calculate_coords" do
    it "sets the values correctly with basic values supplied" do
      options = {left: 30, width: 70, top: 20, height: 85}
      test_calculate_coordinates({x:      options[:left],
                                  width:  options[:width],
                                  y:      options[:top],
                                  height: options[:height]},
                                  options)
    end

    it "sets the values correctly with more complex values" do
      options = {left: 30, right: 45, top: 70, bottom: 15}
      width = app_width - (options[:right] + options[:left])
      height = app_height - (options[:bottom] + options[:top])
      test_calculate_coordinates({x:      options[:left],
                                  width:  width,
                                  y:      options[:top],
                                  height: height},
                                  options)

    end

  end


  # Helper methods
  def create_painter(options = {})
    # the "color" and nil parameters should not be accessed
    Shoes::Background.new parent, blue, options, input_block
  end

  def test_setWH(method, expected, options)
    painter = create_painter options
    painter.send(method, paint_event).should eq expected
  end

  # For the given options we expect set_width to return expected
  def test_set_width(expected, options)
    test_setWH :set_width, expected, options
  end

  def test_set_height(expected, options)
    test_setWH :set_height, expected, options
  end

  def test_set_x(expected, options)
    painter = create_painter(options)
    width = painter.send(:set_width, paint_event)
    painter.send(:set_x, paint_event, width).should eq expected
  end

  def test_set_y(expected, options)
    painter = create_painter(options)
    height = painter.send(:set_height, paint_event)
    painter.send(:set_y, paint_event, height).should eq expected
  end

  def test_calculate_coordinates(expected, options)
    painter = create_painter(options)
    painter.coords(paint_event).should eq expected
  end
end
