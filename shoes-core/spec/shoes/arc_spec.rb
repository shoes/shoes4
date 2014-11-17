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

    it_behaves_like "object with style" do
      let(:subject_without_style) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle) }
      let(:subject_with_style) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle, arg_styles) }
    end
    it_behaves_like "object with dimensions"
    it_behaves_like "left, top as center", :start_angle, :end_angle
    it_behaves_like "object with parent"

    #it_styles_with :art_styles, :center, :dimensions, :radius

    it "is a Shoes::Arc" do
      expect(arc.class).to be(Shoes::Arc)
    end

    its(:angle1) { should eq(0) }
    its(:angle2) { should eq(Shoes::TWO_PI) }
    its(:wedge)  { should eq(false) }
  end

  context "relative dimensions" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, relative_width, relative_height, start_angle, end_angle) }
    it_behaves_like "object with relative dimensions"
  end

  context "negative dimensions" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, -width, -height, 0, Shoes::TWO_PI) }
    it_behaves_like "object with negative dimensions"
  end

  context "with wedge: true" do
    subject(:arc) { Shoes::Arc.new(app, parent, left, top, width, height, start_angle, end_angle, wedge: true) }

    its(:wedge) { should eq(true) }
  end
end
