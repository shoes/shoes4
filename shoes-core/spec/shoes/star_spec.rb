# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Star do
  include_context "dsl app"

  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 100 }
  let(:height) { 100 }

  subject { Shoes::Star.new(app, parent, left, top, 5, 50, 30) }

  it "retains app" do
    expect(subject.app).to eq(app)
  end

  it "creates gui object" do
    expect(subject.gui).not_to be_nil
  end

  it_behaves_like "an art element" do
    let(:subject_without_style) { Shoes::Star.new(app, parent, left, top, 5, 50, 30) }
    let(:subject_with_style) { Shoes::Star.new(app, parent, left, top, 5, 50, 30, arg_styles) }
  end

  describe "in_bounds?" do
    before do
      # Gotta pretend like we've been positioned
      subject.x_dimension.absolute_start = subject.left
      subject.y_dimension.absolute_start = subject.top
    end

    it "in bounds" do
      expect(subject.in_bounds?(50, 50)).to eq(true)
    end

    it "out of bounds" do
      expect(subject.in_bounds?(200, 200)).to eq(false)
    end
  end

  describe "dsl" do
    it "takes no arguments" do
      star = dsl.star
      expect(star).to have_attributes(left: 0,
                                      top: 0,
                                      points: 10,
                                      outer: 100.0,
                                      inner: 50.0)
    end

    it "takes 1 argument" do
      star = dsl.star 10
      expect(star).to have_attributes(left: 10,
                                      top: 0,
                                      points: 10,
                                      outer: 100.0,
                                      inner: 50.0)
    end

    it "takes 1 argument with hash" do
      star = dsl.star 10, top: 20, points: 6, outer: 40
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 6,
                                      outer: 40,
                                      inner: 50.0)
    end

    it "takes 2 arguments" do
      star = dsl.star 10, 20
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 10,
                                      outer: 100.0,
                                      inner: 50.0)
    end

    it "takes 2 arguments with hash" do
      star = dsl.star 10, 20, points: 6, outer: 40
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 6,
                                      outer: 40,
                                      inner: 50.0)
    end

    it "takes 2 arguments with hash side" do
      star = dsl.star 10, 20, points: 6
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 6,
                                      outer: 100.0,
                                      inner: 50.0)
    end

    it "takes 3 arguments" do
      star = dsl.star 10, 20, 6
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 6,
                                      outer: 100.0,
                                      inner: 50.0)
    end

    it "takes 3 arguments with hash" do
      star = dsl.star 10, 20, 6, outer: 30
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 6,
                                      outer: 30,
                                      inner: 50.0)
    end

    it "takes 4 arguments" do
      star = dsl.star 10, 20, 6, 30
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 6,
                                      outer: 30,
                                      inner: 50.0)
    end

    it "takes 4 arguments with hash" do
      star = dsl.star 10, 20, 6, 30, left: -1, top: -2, points: -3, outer: -4
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 6,
                                      outer: 30,
                                      inner: 50.0)
    end

    it "takes 5 arguments" do
      star = dsl.star 10, 20, 6, 30, 40
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 6,
                                      outer: 30,
                                      inner: 40)
    end

    it "takes 5 arguments with hash" do
      star = dsl.star 10, 20, 6, 30, 40,
                      left: -1, top: -2, points: -3, outer: -4, inner: -5
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 6,
                                      outer: 30,
                                      inner: 40)
    end

    it "takes styles hash" do
      star = dsl.star left: 10, top: 20, points: 6, outer: 30, inner: 40
      expect(star).to have_attributes(left: 10,
                                      top: 20,
                                      points: 6,
                                      outer: 30,
                                      inner: 40)
    end

    it "doesn't like too many arguments" do
      expect { dsl.star 10, 20, 6, 30, 40, 666 }.to raise_error(ArgumentError)
    end

    it "doesn't like too many arguments and options too!" do
      expect { dsl.star 10, 20, 6, 30, 40, 666, left: -1 }.to raise_error(ArgumentError)
    end
  end

  describe "redrawing region" do
    subject { Shoes::Star.new(app, parent, 100, 100, 5, 50, 30, center: false, strokewidth: 0) }

    before do
      # faux positioning
      subject.absolute_left = 100
      subject.absolute_top = 100
    end

    it "positions around itself" do
      expect(subject.redraw_left).to eq(100)
      expect(subject.redraw_top).to eq(100)
      expect(subject.redraw_width).to eq(100)
      expect(subject.redraw_height).to eq(100)
    end

    it "positions centered around itself" do
      subject.center = true
      expect(subject.redraw_left).to eq(50)
      expect(subject.redraw_top).to eq(50)
      expect(subject.redraw_width).to eq(100)
      expect(subject.redraw_height).to eq(100)
    end

    it "factors in strokewidth when centered" do
      subject.center = true
      subject.strokewidth = 4
      expect(subject.redraw_left).to eq(46)
      expect(subject.redraw_top).to eq(46)
      expect(subject.redraw_width).to eq(108)
      expect(subject.redraw_height).to eq(108)
    end
  end

  describe "center_point" do
    subject { Shoes::Star.new(app, parent, 125, 175, 5, 50, 30, center: false, strokewidth: 0) }

    it "should return the center point of the star" do
      expect(subject.center_point).to eq(Shoes::Point.new(175, 225))
    end
  end
end
