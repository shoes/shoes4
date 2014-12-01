require 'shoes/swt/spec_helper'

describe Shoes::Swt::ImagePattern do
  let(:dsl)         { Shoes::ImagePattern.new("some/path/to") }
  let(:swt_image)   { double("swt image") }
  let(:swt_pattern) { double("swt pattern") }

  subject { Shoes::Swt::ImagePattern.new(dsl) }

  it_behaves_like "an swt pattern"

  before do
    allow(::Swt::Image).to receive(:new)   { swt_image }
    allow(::Swt::Pattern).to receive(:new) { swt_pattern }
  end

  describe "#dispose" do
    it "disposes of sub-resources" do
      expect(swt_image).to receive(:dispose)
      expect(swt_pattern).to receive(:dispose)

      expect(subject.pattern).to_not be_nil
      subject.dispose
    end
  end

  describe "#apply_as_fill" do
    let(:gc) { double("gc") }

    it "sets background" do
      expect(gc).to receive(:set_background_pattern)
      subject.apply_as_fill(gc, 10, 20, 100, 200)
    end
  end
end
