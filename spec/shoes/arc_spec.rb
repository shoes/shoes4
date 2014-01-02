require 'shoes/spec_helper'

describe Shoes::Arc do
  include_context "dsl app"
  let(:parent) { app }

  let(:left)        { 13 }
  let(:top)         { 44 }
  let(:width)       { 200 }
  let(:height)      { 300 }
  let(:start_angle) { 0 }
  let(:end_angle)   { Shoes::TWO_PI }

  context "basic" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle) }

    it_behaves_like "object with stroke"
    it_behaves_like "object with style"
    it_behaves_like "object with fill"
    it_behaves_like "object with dimensions"
    it_behaves_like "left, top as center", :start_angle, :end_angle
    it_behaves_like 'object with parent'

    it "is a Shoes::Arc" do
      expect(arc.class).to be(Shoes::Arc)
    end

    its(:angle1) { should eq(0) }
    its(:angle2) { should eq(Shoes::TWO_PI) }

    specify "defaults to chord fill" do
      expect(arc).not_to be_wedge
    end
  end

  context "relative dimensions" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, relative_width, relative_height, start_angle, end_angle) }
    it_behaves_like "object with relative dimensions"
  end

  context "negative dimensions" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, -width, -height, 0, Shoes::TWO_PI) }
    it_behaves_like "object with negative dimensions"
  end

  context "wedge" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle, :wedge => true) }

    specify "accepts :wedge => true" do
      expect(arc).to be_wedge
    end
  end
end
