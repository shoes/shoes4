require 'swt_shoes/spec_helper'

describe Shoes::Swt::Arc do
  let(:container) { double('container', disposed?: false) }
  let(:app) { double('app', real: container, add_paint_listener: true) }
  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:angle1) { Shoes::PI }
  let(:angle2) { Shoes::HALF_PI }
  let(:dsl) { double("dsl object", angle1: angle1, angle2: angle2, hidden: false).as_null_object }
  let(:fill_color) { Shoes::Color.new(40, 50, 60, 70) }
  let(:stroke_color) { Shoes::Color.new(80, 90, 100, 110) }

  subject {
    Shoes::Swt::Arc.new(dsl, app, left, top, width, height)
  }

  describe "basics" do
    before :each do
      app.should_receive(:add_paint_listener)
    end

    its(:left) { should eq(left) }
    its(:top) { should eq(top) }
    its(:width) { should eq(width) }
    its(:height) { should eq(height) }

    specify "converts angle1 to degrees" do
      subject.angle1.should eq(180.0)
    end

    specify "converts angle2 to degrees" do
      subject.angle2.should eq(90.0)
    end

    specify "delegates #wedge? to dsl object" do
      dsl.should_receive(:wedge?) { false }
      subject.should_not be_wedge
    end
  end

  it_behaves_like "paintable"

  describe "painter" do
    include_context "painter context"

    let(:shape) { Shoes::Swt::Arc.new(dsl, app, left, top, width, height) }
    subject { Shoes::Swt::Arc::Painter.new(shape) }

    it_behaves_like "stroke painter"
    it_behaves_like "fill painter"

    context "normal fill style" do
      before :each do
        shape.stub(:wedge?) { false }
      end

      specify "fills arc using path" do
        gc.should_receive(:fill_path)
        subject.paint_control(event)
      end

      specify "draws arc" do
        gc.should_receive(:draw_arc)
        subject.paint_control(event)
      end

      # Swt measures the arc counterclockwise, while Shoes measures it clockwise.
      specify "translates DSL values for Swt" do
        path = double('path')
        ::Swt::Path.stub(:new) { path }
        args = [100, 200, width, height, 180.0, -90.0]
        path.should_receive(:add_arc).with(*args)
        sw = 10
        args = [100+sw/2, 200+sw/2, width-sw, height-sw, 180, -90.0]
        gc.should_receive(:draw_arc).with(*args)
        subject.paint_control(gc)
      end
    end

    context "wedge fill style" do
      before :each do
        shape.stub(:wedge?) { true }
      end

      specify "fills arc" do
        gc.should_receive(:fill_arc)
        subject.paint_control(event)
      end

      specify "draws arc" do
        gc.should_receive(:draw_arc)
        subject.paint_control(event)
      end

      specify "translates DSL values for Swt" do
        args = [100, 200, width, height, 180, -90.0]
        gc.should_receive(:fill_arc).with(*args)
        sw = 10
        args = [100+sw/2, 200+sw/2, width-sw, height-sw, 180, -90.0]
        gc.should_receive(:draw_arc).with(*args)
        subject.paint_control(gc)
      end
    end
  end
end
