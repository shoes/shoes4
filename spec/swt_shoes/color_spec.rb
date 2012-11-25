require 'swt_shoes/spec_helper'

describe Shoes::Swt::Color do
  subject { Shoes::Swt::Color.create(Shoes::COLORS[:salmon]) }

  it_behaves_like "an swt pattern"

  its(:class) { should eq(Shoes::Swt::Color) }
  its(:real) { should eq(Swt::Graphics::Color.new(Shoes.display, 250, 128, 114)) }

  describe "#apply_as_fill" do
    let(:gc) { double("gc") }

    it "sets background" do
      gc.stub(:set_alpha)
      gc.should_receive(:set_background).with(subject.real)
      subject.apply_as_fill(gc)
    end

    it "sets alpha" do
      gc.stub(:set_background)
      gc.should_receive(:set_alpha)
      subject.apply_as_fill(gc, 10, 20, 100, 200)
    end
  end
end

describe Shoes::Swt::NullColor do
  subject { Shoes::Swt::Color.create(nil) }

  it { should be_instance_of(Shoes::Swt::NullColor) }
  its(:real) { should be_nil }
  its(:dsl) { should be_nil }
  its(:alpha) { should be_nil }

  describe "pattern interface" do
    let(:gc) { double("graphics context") }

    it "sends no messages in #apply_as_fill" do
      subject.apply_as_fill(gc)
    end

    it "sends no messages in #apply_as_stroke" do
      subject.apply_as_stroke(gc)
    end
  end
end

