# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Swt::ImagePattern do
  let(:dsl)         { Shoes::ImagePattern.new("some/path/to") }
  let(:applied_to)  { double("applied to") }
  let(:swt_image)   { double("swt image") }
  let(:swt_pattern) { double("swt pattern") }

  subject { Shoes::Swt::ImagePattern.new(dsl) }

  it_behaves_like "an swt pattern"

  before do
    allow(::Swt::Image).to receive(:new)   { swt_image }
    allow(::Swt::Pattern).to receive(:new) { swt_pattern }

    allow(::FileUtils).to receive(:cp)
    allow(::FileUtils).to receive(:rm)
  end

  describe "#dispose" do
    it "disposes of sub-resources" do
      expect(swt_image).to receive(:dispose)
      expect(swt_pattern).to receive(:dispose)

      expect(subject.pattern).to_not be_nil
      subject.dispose
    end
  end

  describe "#apply_as_stroke" do
    let(:gc) { double("gc") }

    it "sets foreground" do
      expect(gc).to receive(:set_foreground_pattern)
      subject.apply_as_stroke(gc, applied_to)
    end
  end

  describe "#apply_as_fill" do
    let(:gc) { double("gc") }

    it "sets background" do
      expect(gc).to receive(:set_background_pattern)
      subject.apply_as_fill(gc, applied_to)
    end
  end
end
