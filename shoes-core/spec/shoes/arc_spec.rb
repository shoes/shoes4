# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Arc do
  include_context "dsl app"
  let(:parent) { app }

  let(:left)        { 13 }
  let(:top)         { 44 }
  let(:width)       { 200 }
  let(:height)      { 300 }
  let(:start_angle) { 0 }
  let(:end_angle)   { Shoes::TWO_PI }

  describe "basic" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle) }

    it_behaves_like "an art element" do
      let(:subject_without_style) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle) }
      let(:subject_with_style) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle, arg_styles) }
    end
    it_behaves_like "left, top as center", :start_angle, :end_angle

    it "is a Shoes::Arc" do
      expect(arc.class).to be(Shoes::Arc)
    end

    its(:angle1) { should eq(0) }
    its(:angle2) { should eq(Shoes::TWO_PI) }
    its(:wedge)  { should eq(false) }
  end

  describe "relative dimensions" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, relative_width, relative_height, start_angle, end_angle) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, -width, -height, 0, Shoes::TWO_PI) }
    it_behaves_like "object with negative dimensions"
  end

  describe "with wedge: true" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle, wedge: true) }

    its(:wedge) { should eq(true) }
  end

  describe "center_point" do
    it "should return the center point of the arc" do
      basic_arc = Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle)
      expect(basic_arc.center_point).to eq(Shoes::Point.new(113, 194))
    end

    it "should handle arcs initialized with nil dimensions" do
      nil_arc = Shoes::Arc.new(app, parent, nil, nil, width, height, start_angle, end_angle)
      expect(nil_arc.center_point).to eq(Shoes::Point.new(100, 150))
    end
  end

  describe "center_point=" do
    it "should set a new center_point" do
      basic_arc = Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle)
      basic_arc.center_point = Shoes::Point.new(80, 90)
      expect(basic_arc.center_point).to eq(Shoes::Point.new(80, 90))
    end

    # it "should work for centered arcs" do
    #   centered_arc = Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle, center: true)
    #   centered_arc.center_point = Shoes::Point.new(80, 90)
    #   expect(centered_arc.center_point).to eq(Shoes::Point.new(80, 90))
    # end
  end

  describe "dsl" do
    it "takes no arguments" do
      arc = dsl.arc
      expect(arc).to have_attributes(left: 0,
                                     top: 0,
                                     width: 0,
                                     height: 0,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 1 argument" do
      arc = dsl.arc 10
      expect(arc).to have_attributes(left: 10,
                                     top: 0,
                                     width: 0,
                                     height: 0,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 1 argument with hash" do
      arc = dsl.arc 10, top: 20, width: 30, height: 40
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 2 arguments" do
      arc = dsl.arc 10, 20
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 0,
                                     height: 0,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 2 arguments with hash" do
      arc = dsl.arc 10, 20, width: 30, height: 40
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 2 arguments with hash side" do
      arc = dsl.arc 10, 20, width: 30
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 0,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 3 arguments" do
      arc = dsl.arc 10, 20, 30
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 0,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 3 arguments with hash" do
      arc = dsl.arc 10, 20, 30, height: 40
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 4 arguments" do
      arc = dsl.arc 10, 20, 30, 40
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 4 arguments with hash" do
      arc = dsl.arc 10, 20, 30, 40, left: -1, top: -2, width: -3, height: -4
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: 0,
                                     angle2: 0)
    end

    it "takes 5 arguments" do
      arc = dsl.arc 10, 20, 30, 40, Shoes::PI
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: Shoes::PI,
                                     angle2: 0)
    end

    it "takes 5 arguments with hash" do
      arc = dsl.arc 10, 20, 30, 40, Shoes::PI,
                    left: -1, top: -2, width: -3, height: -4, angle1: -5, angle2: 6
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: Shoes::PI,
                                     angle2: 6)
    end

    it "takes 6 arguments" do
      arc = dsl.arc 10, 20, 30, 40, Shoes::PI, Shoes::TWO_PI
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: Shoes::PI,
                                     angle2: Shoes::TWO_PI)
    end

    it "takes 6 arguments with hash" do
      arc = dsl.arc 10, 20, 30, 40, Shoes::PI, Shoes::TWO_PI,
                    left: -1, top: -2, width: -3, height: -4, angle1: -5, angle2: -6
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: Shoes::PI,
                                     angle2: Shoes::TWO_PI)
    end

    it "takes styles hash" do
      arc = dsl.arc left: 10, top: 20, width: 30, height: 40,
                    angle1: Shoes::PI, angle2: Shoes::TWO_PI
      expect(arc).to have_attributes(left: 10,
                                     top: 20,
                                     width: 30,
                                     height: 40,
                                     angle1: Shoes::PI,
                                     angle2: Shoes::TWO_PI)
    end

    it "doesn't like too many arguments" do
      expect { dsl.arc 10, 20, 30, 40, Shoes::PI, Shoes::TWO_PI, 666 }.to raise_error(ArgumentError)
    end

    it "doesn't like too many arguments and options too!" do
      expect { dsl.arc 10, 20, 30, 40, Shoes::PI, Shoes::TWO_PI, 666, left: -1 }.to raise_error(ArgumentError)
    end
  end
end
