require 'swt_shoes/spec_helper'

describe Shoes::Swt::Color do
  subject { Shoes::Swt::Color.new(Shoes::COLORS[:salmon]) }

  it_behaves_like "an swt pattern"

  its(:class) { should eq(Shoes::Swt::Color) }
  its(:red) { should eq(250) }
  its(:green) { should eq(128) }
  its(:blue) { should eq(114) }

  describe "#apply_as_stroke" do
    let(:gc) { double("graphics context") }

    it "sets foreground" do
      gc.stub(:set_alpha)
      gc.should_receive(:set_foreground)
      subject.apply_as_stroke(gc)
    end

    it "sets alpha" do
      gc.stub(:set_foreground)
      gc.should_receive(:set_alpha)
      subject.apply_as_stroke(gc)
    end
  end

  describe "#apply_as_fill" do
    let(:gc) { double("graphics context") }

    it "sets background" do
      gc.stub(:set_alpha)
      gc.should_receive(:set_background)
      subject.apply_as_fill(gc)
    end

    it "sets alpha" do
      gc.stub(:set_background)
      gc.should_receive(:set_alpha)
      subject.apply_as_fill(gc)
    end
  end
end
