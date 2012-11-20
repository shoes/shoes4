require 'swt_shoes/spec_helper'

describe Shoes::Swt::Color do
  subject { Shoes::Swt::Color.create(Shoes::COLORS[:salmon]) }

  it_behaves_like "an swt pattern"

  its(:class) { should eq(Shoes::Swt::Color) }
  its(:real) { should eq(Swt::Graphics::Color.new(Shoes.display, 250, 128, 114)) }

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

