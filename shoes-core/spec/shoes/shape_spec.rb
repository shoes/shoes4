# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Shape do
  include_context "dsl app"

  let(:left) { 0 }
  let(:top) { 0 }
  let(:width) { 600 }
  let(:height) { 500 }
  let(:style) { {translate_left: 0, translate_top: 0, left: left, top: top} }
  let(:draw)  { proc {} }

  subject { Shoes::Shape.new app, parent, left, top, style, draw }

  it_behaves_like "an art element" do
    let(:subject_without_style) { Shoes::Shape.new(app, parent, left, top) }
    let(:subject_with_style) { Shoes::Shape.new(app, parent, left, top, arg_styles) }
  end

  describe "octagon" do
    let(:draw) do
      proc do
        xs = [200, 300, 370, 370, 300, 200, 130, 130]
        ys = [100, 100, 170, 270, 340, 340, 270, 170]
        move_to xs.first, ys.first
        xs.zip(ys).each do |x, y|
          line_to(x, y)
        end
        line_to xs.first, ys.first
      end
    end

    its(:left) { should eq(0) }
    its(:top) { should eq(0) }
    its(:left_bound) { should eq(130) }
    its(:top_bound) { should eq(100) }
    its(:right_bound) { should eq(370) }
    its(:bottom_bound) { should eq(340) }
    its(:width) { should eq(app.width) }
    its(:height) { should eq app.height }

    it_behaves_like "movable object"

    describe "when created without left and top values" do
      let(:left) { nil }
      let(:top) { nil }

      its(:left) { should eq(0) }
      its(:top) { should eq(0) }
    end

    describe "when created with left and top values" do
      let(:left) { 10 }
      let(:top) { 100 }

      its(:left) { should eq(10) }
      its(:top) { should eq(100) }
      its(:left_bound) { should eq(130) }
      its(:top_bound) { should eq(100) }
      its(:right_bound) { should eq(370) }
      its(:bottom_bound) { should eq(340) }
      its(:width) { should eq(app.width) }
      its(:height) { should eq app.height }
    end
  end

  describe "curve" do
    let(:draw) do
      proc do
        move_to 10, 10
        curve_to 20, 30, 100, 200, 50, 50
      end
    end

    its(:left_bound)   { should eq(10) }
    its(:top_bound)    { should eq(10) }
    its(:right_bound)  { should eq(100) }
    its(:bottom_bound) { should eq(200) }
    its(:width) { should eq(app.width) }
    its(:height) { should eq app.height }

    it_behaves_like "movable object"
  end

  describe "arc" do
    let(:draw) do
      proc do
        arc_to 10, 10, 100, 100, Shoes::PI, Shoes::TWO_PI
      end
    end

    it_behaves_like "movable object"
  end

  describe "in_bounds?" do
    let(:draw) { proc { line_to 100, 100 } }

    it "is in bounds" do
      expect(subject.in_bounds?(10, 10)).to be true
    end

    it "is out of bounds" do
      expect(subject.in_bounds?(101, 101)).to be false
    end
  end

  describe "accesses app" do
    let(:draw) do
      proc do
        background Shoes::COLORS[:red]
        stroke Shoes::COLORS[:blue]
        rect 10, 10, 100, 100
      end
    end

    it_behaves_like "movable object"
  end

  describe "dsl" do
    it "takes no arguments" do
      shape = dsl.shape
      expect(shape).to have_attributes(left: 0, top: 0)
    end

    it "takes 1 argument" do
      shape = dsl.shape 10
      expect(shape).to have_attributes(left: 10, top: 0)
    end

    it "takes 1 argument with hash" do
      shape = dsl.shape 10, top: 20
      expect(shape).to have_attributes(left: 10, top: 20)
    end

    it "takes 2 arguments" do
      shape = dsl.shape 10, 20
      expect(shape).to have_attributes(left: 10, top: 20)
    end

    it "takes 2 arguments with hash" do
      shape = dsl.shape 10, 20, top: 30
      expect(shape).to have_attributes(left: 10, top: 20)
    end

    it "takes styles hash" do
      shape = dsl.shape left: 10, top: 20
      expect(shape).to have_attributes(left: 10, top: 20)
    end

    it "doesn't like too many arguments" do
      expect { dsl.shape 10, 20, 666 }.to raise_error(ArgumentError)
    end

    it "doesn't like too many arguments and options too!" do
      expect { dsl.shape 10, 20, 666, left: -1 }.to raise_error(ArgumentError)
    end
  end
end
