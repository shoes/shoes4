require 'shoes/spec_helper'

describe Shoes::Arc do
  let(:app) { Shoes::App.new }

  context "basic" do
    subject { Shoes::Arc.new(app, 13, 44, 200, 300, 0, Shoes::TWO_PI) }

    it_behaves_like "object with stroke"
    it_behaves_like "object with style"
    it_behaves_like "object with fill"

    it "is a Shoes::Arc" do
      subject.class.should be(Shoes::Arc)
    end

    its(:left) { should eq(13) }
    its(:top) { should eq(44) }
    its(:width) { should eq(200) }
    its(:height) { should eq(300) }
    its(:angle1) { should eq(0) }
    its(:angle2) { should eq(Shoes::TWO_PI) }

    specify "defaults to chord fill" do
      subject.should_not be_wedge
    end

    it "passes required values to backend" do
      gui_opts = {:left => 13, :top => 44, :width => 200, :height => 300, :angle1 => 0, :angle2 => Shoes::TWO_PI}
      Shoes.configuration.backend::Arc.should_receive(:new).with(subject, app.gui, gui_opts)
      subject
    end
  end

  context "wedge" do
    subject { Shoes::Arc.new(app, 13, 44, 200, 300, 0, Shoes::TWO_PI, :wedge => true) }

    specify "accepts :wedge => true" do
      subject.should be_wedge
    end
  end
end
