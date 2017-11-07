# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Swt::Arc do
  include_context "swt app"

  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:angle1) { Shoes::PI }
  let(:angle2) { Shoes::HALF_PI }
  let(:dsl) do
    double("dsl object", app: shoes_app, element_width: width,
                         element_height: height, element_left: left,
                         element_top: top, angle1: angle1, angle2: angle2,
                         wedge?: false, pass_coordinates?: nil,
                         hidden: false).as_null_object
  end

  subject { Shoes::Swt::Arc.new(dsl, swt_app) }

  describe "basics" do
    specify "converts angle1 to degrees" do
      expect(subject.angle1).to eq(180.0)
    end

    specify "converts angle2 to degrees" do
      expect(subject.angle2).to eq(90.0)
    end

    specify "delegates #wedge to dsl object" do
      expect(dsl).to receive(:wedge?) { false }
      expect(subject).to_not be_wedge
    end
  end

  it_behaves_like "paintable"
  it_behaves_like "updating visibility"
  it_behaves_like "clickable backend"
end
