require 'shoes/spec_helper'

describe Shoes::Color do
  describe ".create" do
    let(:color) { Shoes::Color.new(40, 50, 60) }

    it "accepts color" do
      Shoes::Color.create(color).should eq(color)
    end

    it "accepts string" do
      Shoes::Color.create("28323c").should eq(color)
    end
  end

  shared_examples_for "black" do
    its(:class) { should eq(Shoes::Color) }
    its(:red) { should eq(0) }
    its(:green) { should eq(0) }
    its(:blue) { should eq(0) }
    its(:hex) { should eq("#000000") }
    it { should be_black }
    it { should_not be_white }
  end

  shared_examples "color with bad arguments" do
    it "raises ArgumentError" do
      subject.should raise_error(ArgumentError)
    end
  end

  context "with wrong number of arguments" do
    subject { lambda { Shoes::Color.new(10, 10) } }
    it_behaves_like "color with bad arguments"
  end

  context "with too many hex chars" do
    subject { lambda { Shoes::Color.new("a1b2c3d") } }
    it_behaves_like "color with bad arguments"
  end

  context "with too few hex chars" do
    subject { lambda { Shoes::Color.new("a1") } }
    it_behaves_like "color with bad arguments"
  end

  context "with invalid hex chars" do
    subject { lambda { Shoes::Color.new("#g01234") } }
    it_behaves_like "color with bad arguments"
  end

  context "hex" do
    let(:rgb) { Shoes::Color.new(0, 0, 0, 255) }

    context "with '#000000'" do
      subject { Shoes::Color.new("#000000") }
      it { should eq(rgb) }
    end

    context "with '000000'" do
      subject { Shoes::Color.new("000000") }
      it { should eq(rgb) }
    end

    context "with '000'" do
      subject { Shoes::Color.new("000") }
      it { should eq(rgb) }
    end

    context "with '#000'" do
      subject { Shoes::Color.new("#000") }
      it { should eq(rgb) }
    end

    context "with '#FFF'" do
      let(:rgb) { Shoes::Color.new(255, 255, 255) }
      subject { Shoes::Color.new("#FFF") }
      it { should eq(rgb) }
    end

    context "with '#fff'" do
      let(:rgb) { Shoes::Color.new(255, 255, 255) }
      subject { Shoes::Color.new("#fff") }
      it { should eq(rgb) }
    end
  end

  context "rgb" do
    context "black" do
      context "with optional alpha" do
        subject { Shoes::Color.new(0, 0, 0, 0) }
        it_behaves_like "black"
        its(:alpha) { should eq(0) }
      end

      context "without optional alpha" do
        subject { Shoes::Color.new(0, 0, 0) }
        it_behaves_like "black"
        its(:alpha) { should eq(255) }
      end

      context "using floats" do
        context "with optional alpha" do
          subject { Shoes::Color.new(0.0, 0.0, 0.0, 0.0) }
          it_behaves_like "black"
          its(:alpha) { should eq(0) }
        end

        context "without optional alpha" do
          subject { Shoes::Color.new(0.0, 0.0, 0.0) }
          it_behaves_like "black"
          its(:alpha) { should eq(255) }
        end
      end
    end

    context "white" do
      subject { Shoes::Color.new(255, 255, 255) }
      it { should be_white }
      it { should_not be_black }
    end

    context "peru" do
      shared_examples_for "peru" do
        its(:class) { should eq(Shoes::Color) }
        its(:red) { should eq(205) }
        its(:green) { should eq(133) }
        its(:blue) { should eq(63) }
        it { should_not be_black }
        it { should_not be_white }
      end

      context "with optional alpha" do
        subject { Shoes::Color.new(205, 133, 63, 100) }
        it_behaves_like("peru")
        its(:alpha) { should eq(100) }
      end

      context "without optional alpha" do
        subject { Shoes::Color.new(205, 133, 63) }
        it_behaves_like("peru")
        its(:alpha) { should eq(255) }
      end

      context "using floats" do
        let(:red) { 0.805 }
        let(:green) { 0.52 }
        let(:blue) { 0.248 }
        let(:alpha) { 0.392 }

        context "with optional alpha" do
          subject { Shoes::Color.new(red, green, blue, alpha) }
          it_behaves_like "peru"
          its(:alpha) { should eq(100) }
        end

        context "without optional alpha" do
          subject { Shoes::Color.new(red, green, blue) }
          it_behaves_like "peru"
          its(:alpha) { should eq(255) }
        end
      end
    end

    describe "light and dark" do
      let(:lightgreen) { Shoes::Color.new(144, 238, 144) }
      let(:darkgreen) { Shoes::Color.new(0, 100, 0) }
      let(:mediumseagreen) { Shoes::Color.new(60, 179, 113) }

      specify "light color is light" do
        lightgreen.should be_light
        mediumseagreen.should_not be_light
        darkgreen.should_not be_light
      end

      specify "dark color is dark" do
        lightgreen.should_not be_dark
        mediumseagreen.should_not be_dark
        darkgreen.should be_dark
      end
    end

    describe "transparency" do
      let(:transparent) { Shoes::Color.new(25, 25, 112, 0) }
      let(:semi) { Shoes::Color.new(25, 25, 112, 100) }
      let(:opaque) { Shoes::Color.new(25, 25, 25) }

      specify "only transparent colors are transparent" do
        transparent.should be_transparent
        semi.should_not be_transparent
        opaque.should_not be_transparent
      end

      specify "only opaque colors should be opaque" do
        transparent.should_not be_opaque
        semi.should_not be_opaque
        opaque.should be_opaque
      end
    end

    describe "comparable" do
      let(:color_1) { Shoes::Color.new(255, 69, 0) } # orangered

      it "is equal when values are equal" do
        color_2 = Shoes::Color.new(255, 69, 0)
        color_1.should eq(color_2)
      end

      it "is less than when darker" do
        color_2 = Shoes::Color.new(255, 70, 0)
        color_1.should be < color_2
      end

      it "is greater than when lighter" do
        color_2 = Shoes::Color.new(255, 68, 0)
        color_1.should be > color_2
      end

      context "same rgb values" do
        let(:color_2) { Shoes::Color.new(255, 69, 0, 254) }
        it "is less than when less opaque" do
          color_2.should be < color_1
        end

        it "is greater than when more opaque" do
          color_1.should be > color_2
        end
      end
    end
  end
end

describe "Shoes built-in colors" do
  specify "there are 140" do
    Shoes::COLORS.length.should eq(140)
  end

  class MockApp
    include Shoes::DSL
  end

  subject { MockApp.new }

  its(:papayawhip) { should eq(Shoes::Color.new(255, 239, 213)) }
  its(:aquamarine) { should eq(Shoes::Color.new(127, 255, 212)) }
  its(:tomato) { should eq(Shoes::Color.new(255, 99, 71)) }
end

describe "Shoes built in gray" do
  let(:app) { Shoes::App.new }

  it "creates a dsl method for gray" do
    app.should respond_to(:gray)
  end

  specify "gray with no parameters is [128, 128, 128, OPAQUE]" do
    app.gray.should eq(Shoes::Color.new(128, 128, 128))
  end

  specify "single parameter specifies the gray level" do
    app.gray(64).should eq(Shoes::Color.new(64, 64, 64))
  end

  specify "two parameters specifies the gray level and opacity" do
    app.gray(13, 57).should eq(Shoes::Color.new(13, 13, 13, 57))
  end

  specify "float parameters should be normalised" do
    app.gray(1.0, 0.5).should eq(Shoes::Color.new( 255, 255, 255, 128 ))
  end
end

# Differences between this implementation and Red Shoes
describe "differences from Red Shoes" do
  let(:white) { Shoes::Color.new(255, 255, 255) }
  let(:transparent_black) { Shoes::Color.new(0, 0, 0, 0) }

  context "integers" do
    specify "too-large values become 255" do
      Shoes::Color.new(256, 256, 256, 256).should eq(white)
    end

    specify "too-small values become 0" do
      Shoes::Color.new(-1, -1, -1, -1).should eq(transparent_black)
    end
  end

  context "floats" do
    specify "too-large values become 255" do
      Shoes::Color.new(1.1, 1.1, 1.1, 1.1).should eq(white)
    end

    specify "too-small values become 0" do
      Shoes::Color.new(-0.1, -0.1, -0.1, -0.1).should eq(transparent_black)
    end
  end

  # These specifications describe how this implementation differs from Red Shoes.
  # These are examples of what Red Shoes _does_ do, and what this implementation
  # _does not_ do.
  describe "unusual input" do
    let(:baseline) { Shoes::Color.new(50, 0, 200) }

    describe "too-large values" do
      specify "red does not get modulo-256'd into bounds" do
        Shoes::Color.new(306, 0, 200).should_not eq(baseline)
        Shoes::Color.new(1.197, 0, 200).should_not eq(baseline)
      end

      specify "green does not get modulo-256'd into bounds" do
        Shoes::Color.new(50, 256, 200).should_not eq(baseline)
        Shoes::Color.new(50, 2.005, 200).should_not eq(baseline)
      end

      specify "blue does not get modulo-256'd into bounds" do
        Shoes::Color.new(50, 0, 456).should_not eq(baseline)
        Shoes::Color.new(50, 0, 2.7913137254902).should_not eq(baseline)
      end
    end

    describe "negative values" do
      specify "-1 does not become 255" do
        Shoes::Color.new(-1, -1, -1, -1).should_not eq(Shoes::Color.new(255, 255, 255))
      end

      specify "256 and neighbors" do
        Shoes::Color.new(-256, -255, -257).should_not eq(Shoes::Color.new(0, 1, 255))
      end

      specify "float behaviour" do
        Shoes::Color.new(-1.0, -0.5, -0.0).should_not eq(Shoes::Color.new(0, 128, 1))
      end
    end

    describe "edge cases" do
      specify "0.0 does not become 1" do
        Shoes::Color.new(0.0, 0.0, 0.0).should_not eq(Shoes::Color.new(1, 1, 1))
      end

      specify "1.0 does not become 0" do
        Shoes::Color.new(1.0, 1.0, 1.0).should_not eq(Shoes::Color.new(0, 0, 0))
      end
    end
  end
end
