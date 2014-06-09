require 'shoes/spec_helper'

describe Shoes::Color do
  describe ".create" do
    let(:color) { Shoes::Color.new(40, 50, 60) }

    it "accepts color" do
      expect(Shoes::Color.create(color)).to eq(color)
    end

    it "accepts string" do
      expect(Shoes::Color.create("28323c")).to eq(color)
    end
  end

  shared_examples_for "black" do
    its(:class) { should eq(Shoes::Color) }
    its(:red) { should eq(0) }
    its(:green) { should eq(0) }
    its(:blue) { should eq(0) }
    its(:hex) { should eq("#000000") }
    it { is_expected.to be_black }
    it { is_expected.not_to be_white }
  end

  shared_examples "color with bad arguments" do
    it "raises ArgumentError" do
      expect(subject).to raise_error(ArgumentError)
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
      it { is_expected.to eq(rgb) }
    end

    context "with '000000'" do
      subject { Shoes::Color.new("000000") }
      it { is_expected.to eq(rgb) }
    end

    context "with '000'" do
      subject { Shoes::Color.new("000") }
      it { is_expected.to eq(rgb) }
    end

    context "with '#000'" do
      subject { Shoes::Color.new("#000") }
      it { is_expected.to eq(rgb) }
    end

    context "with '#FFF'" do
      let(:rgb) { Shoes::Color.new(255, 255, 255) }
      subject { Shoes::Color.new("#FFF") }
      it { is_expected.to eq(rgb) }
    end

    context "with '#fff'" do
      let(:rgb) { Shoes::Color.new(255, 255, 255) }
      subject { Shoes::Color.new("#fff") }
      it { is_expected.to eq(rgb) }
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

    describe "inspect" do
      include InspectHelpers

      # Using patterns here so we can handle the variable hex string identifier
      let(:rgb_pattern) { 'rgb[(]10, 20, 30[)]' }
      let(:inspect_pattern) { "[(]Shoes::Color:#{shoes_object_id_pattern} #{rgb_pattern} alpha:40[)]$" }
      subject(:color) { Shoes::Color.new(10, 20, 30, 40) }

      its(:to_s) { should match(rgb_pattern) }
      its(:inspect) { should match(inspect_pattern) }
    end

    context "white" do
      subject { Shoes::Color.new(255, 255, 255) }
      it { is_expected.to be_white }
      it { is_expected.not_to be_black }
    end

    context "peru" do
      shared_examples_for "peru" do
        its(:class) { should eq(Shoes::Color) }
        its(:red) { should eq(205) }
        its(:green) { should eq(133) }
        its(:blue) { should eq(63) }
        it { is_expected.not_to be_black }
        it { is_expected.not_to be_white }
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
        expect(lightgreen).to be_light
        expect(mediumseagreen).not_to be_light
        expect(darkgreen).not_to be_light
      end

      specify "dark color is dark" do
        expect(lightgreen).not_to be_dark
        expect(mediumseagreen).not_to be_dark
        expect(darkgreen).to be_dark
      end
    end

    describe "transparency" do
      let(:transparent) { Shoes::Color.new(25, 25, 112, 0) }
      let(:semi) { Shoes::Color.new(25, 25, 112, 100) }
      let(:opaque) { Shoes::Color.new(25, 25, 25) }

      specify "only transparent colors are transparent" do
        expect(transparent).to be_transparent
        expect(semi).not_to be_transparent
        expect(opaque).not_to be_transparent
      end

      specify "only opaque colors should be opaque" do
        expect(transparent).not_to be_opaque
        expect(semi).not_to be_opaque
        expect(opaque).to be_opaque
      end
    end

    describe "comparable" do
      let(:color_1) { Shoes::Color.new(255, 69, 0) }
      let(:red) {Shoes::Color.new 255, 0, 0}
      let(:green) {Shoes::Color.new 0, 255, 0}

      it "is equal when values are equal" do
        color_2 = Shoes::Color.new(255, 69, 0)
        expect(color_1).to eq(color_2)
      end

      it "is less than when darker" do
        color_2 = Shoes::Color.new(255, 70, 0)
        expect(color_1).to be < color_2
      end

      it "is greater than when lighter" do
        color_2 = Shoes::Color.new(255, 68, 0)
        expect(color_1).to be > color_2
      end

      it 'does not claim for full red and full green to be equal' do
        expect(red).not_to eq green
      end

      it 'claims that a color is the same as itself' do
        expect(green).to eq green
      end

      context "same rgb values" do
        let(:color_2) { Shoes::Color.new(255, 69, 0, 254) }
        it "is less than when less opaque" do
          expect(color_2).to be < color_1
        end

        it "is greater than when more opaque" do
          expect(color_1).to be > color_2
        end
      end
    end
  end
end

describe "Shoes built-in colors" do
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
    expect(app).to respond_to(:gray)
  end

  specify "gray with no parameters is [128, 128, 128, OPAQUE]" do
    expect(app.gray).to eq(Shoes::Color.new(128, 128, 128))
  end

  specify "single parameter specifies the gray level" do
    expect(app.gray(64)).to eq(Shoes::Color.new(64, 64, 64))
  end

  specify "two parameters specifies the gray level and opacity" do
    expect(app.gray(13, 57)).to eq(Shoes::Color.new(13, 13, 13, 57))
  end

  specify "float parameters should be normalised" do
    expect(app.gray(1.0, 0.5)).to eq(Shoes::Color.new( 255, 255, 255, 128 ))
  end

  it 'hangles 0.93 right as well' do
    result_93 = (0.93 * 255).to_i
    expect(app.gray(0.93)).to eq(Shoes::Color.new(result_93, result_93, result_93))
  end

  it 'also has a grey alias for our BE friends' do
    expect(app).to respond_to :grey
  end
end

# Differences between this implementation and Red Shoes
describe "differences from Red Shoes" do
  let(:white) { Shoes::Color.new(255, 255, 255) }
  let(:transparent_black) { Shoes::Color.new(0, 0, 0, 0) }

  context "integers" do
    specify "too-large values become 255" do
      expect(Shoes::Color.new(256, 256, 256, 256)).to eq(white)
    end

    specify "too-small values become 0" do
      expect(Shoes::Color.new(-1, -1, -1, -1)).to eq(transparent_black)
    end
  end

  context "floats" do
    specify "too-large values become 255" do
      expect(Shoes::Color.new(1.1, 1.1, 1.1, 1.1)).to eq(white)
    end

    specify "too-small values become 0" do
      expect(Shoes::Color.new(-0.1, -0.1, -0.1, -0.1)).to eq(transparent_black)
    end
  end

  # These specifications describe how this implementation differs from Red Shoes.
  # These are examples of what Red Shoes _does_ do, and what this implementation
  # _does not_ do.
  describe "unusual input" do
    let(:baseline) { Shoes::Color.new(50, 0, 200) }

    describe "too-large values" do
      specify "red does not get modulo-256'd into bounds" do
        expect(Shoes::Color.new(306, 0, 200)).not_to eq(baseline)
        expect(Shoes::Color.new(1.197, 0, 200)).not_to eq(baseline)
      end

      specify "green does not get modulo-256'd into bounds" do
        expect(Shoes::Color.new(50, 256, 200)).not_to eq(baseline)
        expect(Shoes::Color.new(50, 2.005, 200)).not_to eq(baseline)
      end

      specify "blue does not get modulo-256'd into bounds" do
        expect(Shoes::Color.new(50, 0, 456)).not_to eq(baseline)
        expect(Shoes::Color.new(50, 0, 2.7913137254902)).not_to eq(baseline)
      end
    end

    describe "negative values" do
      specify "-1 does not become 255" do
        expect(Shoes::Color.new(-1, -1, -1, -1)).not_to eq(Shoes::Color.new(255, 255, 255))
      end

      specify "256 and neighbors" do
        expect(Shoes::Color.new(-256, -255, -257)).not_to eq(Shoes::Color.new(0, 1, 255))
      end

      specify "float behaviour" do
        expect(Shoes::Color.new(-1.0, -0.5, -0.0)).not_to eq(Shoes::Color.new(0, 128, 1))
      end
    end

    describe "edge cases" do
      specify "0.0 does not become 1" do
        expect(Shoes::Color.new(0.0, 0.0, 0.0)).not_to eq(Shoes::Color.new(1, 1, 1))
      end

      specify "1.0 does not become 0" do
        expect(Shoes::Color.new(1.0, 1.0, 1.0)).not_to eq(Shoes::Color.new(0, 0, 0))
      end
    end
  end
end

describe Shoes::Color::DSLHelpers do
  class ColorDSLHelperTest
    include Shoes::Color::DSLHelpers
  end

  subject {ColorDSLHelperTest.new}

  describe '#pattern' do
    it 'creates an image pattern when fed a string for which a file exists' do
      allow(File).to receive_messages(exist?: true)
      my_path = '/some/path/to/image.png'
      image_pattern = subject.pattern(my_path)
      expect(image_pattern.path).to eq my_path
    end

    it 'raises an argument error for bad input like a single number' do
      expect {subject.pattern(1)}.to raise_error(ArgumentError)
    end

    it 'creates a gradient given 2 arguments' do
      expect(subject).to receive(:gradient)
      subject.pattern([10, 10, 10], [30, 30, 30])
    end
  end

  describe '#gradient' do
    it 'raises an argument error for no arguments supplied' do
      expect{subject.gradient}.to raise_error ArgumentError
    end

    it 'raises an argument error for too many (> 2) args supplied' do
      expect{subject.gradient 1, 2, 3}.to raise_error ArgumentError
    end
  end
end
