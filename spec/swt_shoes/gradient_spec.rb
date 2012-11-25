require 'swt_shoes/spec_helper'

describe Shoes::Swt::Gradient do
  let(:color1) { Shoes::Color.create(Shoes::COLORS[:honeydew]) }
  let(:color2) { Shoes::Color.create(Shoes::COLORS[:salmon]) }
  let(:dsl) { Shoes::Gradient.new(color1, color2) }

  subject { Shoes::Swt::Gradient.new(dsl) }

  it_behaves_like "an swt pattern"

   describe "#apply_as_fill" do
    let(:gc) { double("gc") }

    it "sets background" do
      gc.should_receive(:set_background_pattern)
      subject.apply_as_fill(gc, 10, 20, 100, 200)
    end
  end 
end
