require 'spec_helper'

describe Shoes::Swt::ArcPainter do
  include_context "swt app"

  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:angle1) { Shoes::PI }
  let(:angle2) { Shoes::HALF_PI }
  let(:fill_color) { Shoes::Color.new(40, 50, 60, 70) }
  let(:stroke_color) { Shoes::Color.new(80, 90, 100, 110) }
  let(:dsl) do
    double("dsl object", app: shoes_app,
                         element_width: width, element_height: height,
                         element_left: left, element_top: top,
                         translate_left: 0, translate_top: 0,
                         angle1: angle1, angle2: angle2,
                         wedge?: false, pass_coordinates?: nil,
                         hidden: false).as_null_object
  end

  include_context "painter context"

  let(:shape) { Shoes::Swt::Arc.new(dsl, swt_app) }
  subject { Shoes::Swt::ArcPainter.new(shape) }

  it_behaves_like "stroke painter"
  it_behaves_like "fill painter"

  context "normal fill style" do
    before :each do
      allow(shape).to receive_messages(wedge?: false)
    end

    specify "fills arc using path" do
      expect(gc).to receive(:fill_path)
      subject.paint_control(event)
    end

    specify "draws arc" do
      expect(gc).to receive(:draw_arc)
      subject.paint_control(event)
    end

    # Swt measures the arc counterclockwise, while Shoes measures it clockwise.
    specify "translates DSL values for Swt" do
      path = double('path')
      allow(::Swt::Path).to receive(:new) { path }
      args = [100, 200, width, height, 180.0, -90.0]
      expect(path).to receive(:add_arc).with(*args)
      sw = 10
      args = [100 + sw / 2, 200 + sw / 2, width - sw, height - sw, 180, -90.0]
      expect(gc).to receive(:draw_arc).with(*args)
      subject.paint_control(gc)
    end
  end

  context "wedge fill style" do
    before :each do
      allow(shape).to receive_messages(wedge?: true)
    end

    specify "fills arc" do
      expect(gc).to receive(:fill_arc)
      subject.paint_control(event)
    end

    specify "draws arc" do
      expect(gc).to receive(:draw_arc)
      subject.paint_control(event)
    end

    specify "translates DSL values for Swt" do
      args = [100, 200, width, height, 180, -90.0]
      expect(gc).to receive(:fill_arc).with(*args)
      sw = 10
      args = [100 + sw / 2, 200 + sw / 2, width - sw, height - sw, 180, -90.0]
      expect(gc).to receive(:draw_arc).with(*args)
      subject.paint_control(gc)
    end
  end
end
