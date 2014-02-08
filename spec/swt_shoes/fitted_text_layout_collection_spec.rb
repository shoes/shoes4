require 'swt_shoes/spec_helper'

describe Shoes::Swt::FittedTextLayoutCollection do
  let(:first_layout) { create_layout("first", "first") }
  let(:second_layout) { create_layout("second", "rest") }
  let(:gc) { double("gc") }

  context "with one layout" do
    subject { Shoes::Swt::FittedTextLayoutCollection.new([first_layout]) }

    it "should have length" do
      expect(subject.length).to eq(1)
    end

    it "delegates drawing" do
      subject.draw(gc)
      expect(first_layout).to have_received(:draw)
    end
  end

  context "with two layouts" do
    subject { Shoes::Swt::FittedTextLayoutCollection.new([first_layout, second_layout]) }

    it "should have length" do
      expect(subject.length).to eq(2)
    end

    it "picks range in first layout" do
      result = subject.ranges_for(0..2)
      expect(result).to eql([[first_layout, 0..2]])
    end

    it "picks range in second layout" do
      result = subject.ranges_for(5..7)
      expect(result).to eql([[second_layout, 0..2]])
    end

    it "spans both layouts" do
      result = subject.ranges_for(2..7)
      expect(result).to eql([[first_layout, 2..5],
                             [second_layout,  0..2]])
    end
  end

  def create_layout(name, text)
    layout = Shoes::Swt::FittedTextLayout.new(double(name, :text => text), 0, 0)
    layout.stub(:draw)
    layout
  end
end
