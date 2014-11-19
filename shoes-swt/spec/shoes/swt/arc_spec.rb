require 'shoes/swt/spec_helper'

describe Shoes::Swt::Arc do
  include_context "swt app"

  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:angle1) { Shoes::PI }
  let(:angle2) { Shoes::HALF_PI }
  let(:dsl) { double("dsl object", app: shoes_app, element_width: width,
                     element_height: height, element_left: left,
                     element_top: top, angle1: angle1, angle2: angle2,
                     wedge?: false, pass_coordinates?: nil,
                     hidden: false).as_null_object }
  let(:fill_color) { Shoes::Color.new(40, 50, 60, 70) }
  let(:stroke_color) { Shoes::Color.new(80, 90, 100, 110) }

  subject { Shoes::Swt::Arc.new(dsl, swt_app) }

  describe "basics" do
    specify "converts angle1 to degrees" do
      expect(subject.angle1).to eq(180.0)
    end

    specify "converts angle2 to degrees" do
      expect(subject.angle2).to eq(90.0)
    end

    specify "delegates #wedge to dsl object" do
      expect(dsl).to receive(:wedge?) { false }
      expect(subject).to_not be_wedge
    end
  end

  it_behaves_like "paintable"
  it_behaves_like "updating visibility"
  it_behaves_like "clickable backend"

  describe "painter" do
    include_context "painter context"

    let(:shape) { Shoes::Swt::Arc.new(dsl, swt_app) }
    subject { Shoes::Swt::Arc::Painter.new(shape) }

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
        args = [100+sw/2, 200+sw/2, width-sw, height-sw, 180, -90.0]
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
        args = [100+sw/2, 200+sw/2, width-sw, height-sw, 180, -90.0]
        expect(gc).to receive(:draw_arc).with(*args)
        subject.paint_control(gc)
      end
    end
  end
end
