# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Arrow do
  include_context "dsl app"

  let(:parent) { app }
  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 111 }
  let(:height) { 111 }
  subject(:arrow) { Shoes::Arrow.new(app, parent, left, top, width) }

  describe '#style' do
    it 'restyles handed in fill colors (even the weird ones)' do
      subject.style fill: 'fff'
      expect(subject.style[:fill]).to eq Shoes::Color.new 255, 255, 255
    end
  end

  it_behaves_like "an art element" do
    let(:subject_without_style) { Shoes::Arrow.new(app, parent, left, top, width) }
    let(:subject_with_style) { Shoes::Arrow.new(app, parent, left, top, width, arg_styles) }
  end

  describe "dsl" do
    it "takes no arguments" do
      arrow = dsl.arrow
      expect(arrow).to have_attributes(left: 0,
                                       top: 0,
                                       width: 0)
    end

    it "takes 1 argument" do
      arrow = dsl.arrow 40
      expect(arrow).to have_attributes(left: 40,
                                       top: 0,
                                       width: 0)
    end

    it "takes 1 argument with options" do
      arrow = dsl.arrow 40, top: 50
      expect(arrow).to have_attributes(left: 40,
                                       top: 50,
                                       width: 0)
    end

    it "takes 2 arguments" do
      arrow = dsl.arrow 40, 50
      expect(arrow).to have_attributes(left: 40,
                                       top: 50,
                                       width: 0)
    end

    it "takes 2 arguments with options" do
      arrow = dsl.arrow 40, 50, width: 100
      expect(arrow).to have_attributes(left: 40,
                                       top: 50,
                                       width: 100)
    end

    it "takes 3 arguments" do
      arrow = dsl.arrow 40, 50, 100
      expect(arrow).to have_attributes(left: 40,
                                       top: 50,
                                       width: 100)
    end

    it "takes 3 arguments with options" do
      arrow = dsl.arrow 40, 50, 100, left: -1, top: -2, width: -3
      expect(arrow).to have_attributes(left: 40,
                                       top: 50,
                                       width: 100)
    end

    it "takes styles hash" do
      arrow = dsl.arrow left: 40, top: 50, width: 100
      expect(arrow).to have_attributes(left: 40,
                                       top: 50,
                                       width: 100)
    end

    it "doesn't like too many arguments" do
      expect { dsl.arrow 40, 50, 100, 666 }.to raise_error(ArgumentError)
    end

    it "doesn't like too many arguments and options too!" do
      expect { dsl.arrow 40, 50, 100, 666, left: -1 }.to raise_error(ArgumentError)
    end
  end

  describe "redrawing region" do
    subject(:arrow) { Shoes::Arrow.new(app, parent, 100, 100, 100, strokewidth: 0) }

    before do
      # faux positioning
      arrow.absolute_left = 100
      arrow.absolute_top = 100
    end

    it "positions around itself" do
      expect(arrow.redraw_left).to eq(50)
      expect(arrow.redraw_top).to eq(60)
      expect(arrow.redraw_width).to eq(100)
      expect(arrow.redraw_height).to eq(100)
    end

    it "factors in strokewidth" do
      arrow.strokewidth = 5
      expect(arrow.redraw_left).to eq(40)
      expect(arrow.redraw_top).to eq(50)
      expect(arrow.redraw_width).to eq(120)
      expect(arrow.redraw_height).to eq(120)
    end
  end
end
