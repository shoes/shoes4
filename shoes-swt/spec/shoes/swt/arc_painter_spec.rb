# frozen_string_literal: true

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
    double("dsl object", app: shoes_app, parent: parent,
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
      args = [left, top, width, height, -180.0, -270.0]
      expect(path).to receive(:add_arc).with(*args)

      line_width = 10
      args = [100 + line_width / 2, 200 + line_width / 2,
              width - line_width, height - line_width,
              -180, -270.0]
      expect(gc).to receive(:fill_path).with(path)
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
      args = [left, top, width, height, -180, -270.0]
      expect(gc).to receive(:fill_arc).with(*args)

      line_width = 10
      args = [100 + line_width / 2, 200 + line_width / 2,
              width - line_width, height - line_width,
              -180, -270.0]
      expect(gc).to receive(:draw_arc).with(*args)
      subject.paint_control(gc)
    end
  end

  describe "half-way around" do
    # In this and the following specs, a diagram is given that shows what part
    # of the arc is included based on the start/end angles. The dotted section
    # is the sweep through which the arc will be filled, empty sections are
    # not included.
    #
    # Note, how the arc will actually draw depends on the wedge? setting, but
    # these diagrams demonstrate how the start/end angles relate.
    #
    #   ---------
    #  /         \
    # |           |
    # |...........|
    # |...........|
    #  \........./
    #   ---------
    #

    let(:angle1) { 0 }
    let(:angle2) { Shoes::PI }
    it { is_expected.to have_attributes(start_angle: 0, sweep: -180) }
  end

  describe "quarter turn" do
    #
    #   ---------
    #  /         \
    # |           |
    # |......     |
    # |......     |
    #  \.....    /
    #   ---------
    #

    let(:angle1) { Shoes::HALF_PI }
    let(:angle2) { Shoes::PI }
    it { is_expected.to have_attributes(start_angle: -90, sweep: -90) }
  end

  describe "three-quarters turn" do
    #
    #   ---------
    #  /.........\
    # |...........|
    # |...........|
    # |......     |
    #  \.....    /
    #   ---------
    #

    let(:angle1) { Shoes::HALF_PI }
    let(:angle2) { Shoes::TWO_PI }
    it { is_expected.to have_attributes(start_angle: -90, sweep: -270) }
  end

  describe "half up to start" do
    #
    #   ---------
    #  /.........\
    # |...........|
    # |...........|
    # |           |
    #  \         /
    #   ---------
    #

    let(:angle1) { Shoes::PI }
    let(:angle2) { 0 }
    it { is_expected.to have_attributes(start_angle: -180, sweep: -180) }
  end

  describe "half over the start" do
    #
    #   ---------
    #  /     ....\
    # |      .....|
    # |      .....|
    # |      .....|
    #  \     ..../
    #   ---------
    #

    let(:angle1) { Shoes::PI + Shoes::HALF_PI }
    let(:angle2) { Shoes::HALF_PI }
    it { is_expected.to have_attributes(start_angle: -270, sweep: -180) }
  end

  describe "start to start" do
    #
    #   ---------
    #  /         \
    # |           |
    # |           |
    # |           |
    #  \         /
    #   ---------
    #

    let(:angle1) { 0 }
    let(:angle2) { 0 }
    it { is_expected.to have_attributes(start_angle: 0, sweep: 0) }
  end

  describe "start to end" do
    #
    #   ---------
    #  /.........\
    # |...........|
    # |...........|
    # |...........|
    #  \........./
    #   ---------
    #

    let(:angle1) { 0 }
    let(:angle2) { Shoes::TWO_PI }
    it { is_expected.to have_attributes(start_angle: 0, sweep: -360) }
  end

  describe "start to end" do
    #
    #   ---------
    #  /.........\
    # |...........|
    # |...........|
    # |...........|
    #  \........./
    #   ---------
    #

    let(:angle1) { 0 }
    let(:angle2) { 3 * Shoes::PI }
    it { is_expected.to have_attributes(start_angle: 0, sweep: -540) }
  end
end
