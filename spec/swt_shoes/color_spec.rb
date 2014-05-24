require 'swt_shoes/spec_helper'

describe Shoes::Swt::Color do
  subject(:color) { Shoes::Swt::Color.create(Shoes::COLORS[:salmon]) }

  it_behaves_like "an swt pattern"

  its(:class) { should eq(Shoes::Swt::Color) }

  describe "underlying SWT object" do
    let(:real) { color.real }

    it "is a native SWT color" do
      expect(real.class).to eq(::Swt::Graphics::Color)
    end

    it "has same red value as Shoes color" do
      expect(real.red).to eq(250)
    end

    it "has same green value as Shoes color" do
      expect(real.green).to eq(128)
    end

    it "has same blue value as Shoes color" do
      expect(real.blue).to eq(114)
    end
  end

  describe "#apply_as_fill" do
    let(:gc) { double("gc") }

    it "sets background" do
      gc.stub(:set_alpha)
      expect(gc).to receive(:set_background).with(color.real)
      color.apply_as_fill(gc)
    end

    it "sets alpha" do
      gc.stub(:set_background)
      expect(gc).to receive(:set_alpha)
      color.apply_as_fill(gc, 10, 20, 100, 200)
    end
  end
end

describe Shoes::Swt::NullColor do
  subject(:color) { Shoes::Swt::Color.create(nil) }

  it { should be_instance_of(Shoes::Swt::NullColor) }
  its(:real) { should be_nil }
  its(:dsl) { should be_nil }
  its(:alpha) { should be_nil }

  describe "pattern interface" do
    let(:gc) { double("graphics context") }

    it "sends no messages in #apply_as_fill" do
      color.apply_as_fill(gc)
    end

    it "sends no messages in #apply_as_stroke" do
      color.apply_as_stroke(gc)
    end
  end
end

