require 'shoes/spec_helper'

describe Shoes::Arc do
  let(:left)   { 13 }
  let(:top)    { 44 }
  let(:width)  { 200 }
  let(:height) { 300 }
  let(:parent) { Shoes::App.new }

  context "basic" do
    subject { Shoes::Arc.new(parent, left, top, width, height, 0, Shoes::TWO_PI) }

    it_behaves_like "object with stroke"
    it_behaves_like "object with style"
    it_behaves_like "object with fill"
    it_behaves_like "object with dimensions"

    it "is a Shoes::Arc" do
      subject.class.should be(Shoes::Arc)
    end

    its(:angle1) { should eq(0) }
    its(:angle2) { should eq(Shoes::TWO_PI) }

    specify "defaults to chord fill" do
      subject.should_not be_wedge
    end

    it "passes required values to backend" do
      gui_opts = {
        :left => left,
        :top => top,
        :width => width,
        :height => height,
        :angle1 => 0,
        :angle2 => Shoes::TWO_PI
      }
      Shoes.configuration.backend::Arc.should_receive(:new).with(subject, parent.gui, gui_opts)
      subject
    end
  end

  context "relative dimensions" do
    subject { Shoes::Arc.new(parent, left, top, relative_width, relative_height, 0, Shoes::TWO_PI) }

    it_behaves_like "object with relative dimensions"
  end

  context "wedge" do
    subject { Shoes::Arc.new(parent, left, top, width, height, 0, Shoes::TWO_PI, :wedge => true) }

    specify "accepts :wedge => true" do
      subject.should be_wedge
    end
  end
end
