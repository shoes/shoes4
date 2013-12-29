require 'shoes/spec_helper'

describe Shoes::Arc do
  let(:left)        { 13 }
  let(:top)         { 44 }
  let(:width)       { 200 }
  let(:height)      { 300 }
  let(:start_angle) { 0 }
  let(:end_angle)   { Shoes::TWO_PI }
  let(:app)         { Shoes::App.new }
  let(:parent)      { app }

  context "basic" do
    subject { Shoes::Arc.new(app, app, left, top, width, height, start_angle, end_angle) }

    it_behaves_like "object with stroke"
    it_behaves_like "object with style"
    it_behaves_like "object with fill"
    it_behaves_like "object with dimensions"
    it_behaves_like "left, top as center", :start_angle, :end_angle
    it_behaves_like 'object with parent'

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
        :angle1 => start_angle,
        :angle2 => end_angle
      }
      Shoes.configuration.backend::Arc.should_receive(:new).with(subject, app.gui, gui_opts)
      subject
    end
  end

  context "relative dimensions" do
    subject { Shoes::Arc.new(app, app, left, top, relative_width, relative_height, start_angle, end_angle) }

    it_behaves_like "object with relative dimensions"
  end

  context "negative dimensions" do
    subject { Shoes::Arc.new(app, app, left, top, -width, -height, 0, Shoes::TWO_PI) }
    it_behaves_like "object with negative dimensions"
  end

  context "wedge" do
    subject { Shoes::Arc.new(app, app, left, top, width, height, start_angle, end_angle, :wedge => true) }

    specify "accepts :wedge => true" do
      subject.should be_wedge
    end
  end

end
