require 'shoes/swt/spec_helper'

describe Shoes::Swt::Star do
  include_context "swt app"

  let(:left) { 55 }
  let(:top) { 77 }
  let(:points) { 7 }
  let(:outer) { 100 }
  let(:inner) { 20 }
  let(:dsl) { Shoes::Star.new shoes_app, parent, left, top, points, outer, inner }

  subject { Shoes::Swt::Star.new dsl, swt_app }

  context "#initialize" do
    its(:dsl) { is_expected.to be(dsl) }
  end

  it_behaves_like "paintable"
  it_behaves_like "updating visibility"
  it_behaves_like 'clickable backend'

  describe "painter" do
    include_context "painter context"

    let(:corners) { 0 }
    let(:dsl) { double("dsl object", hidden: false, points: points, outer: outer,
                       inner: inner, element_width: outer * 2.0,
                       element_height: outer * 2.0, element_left: left,
                       element_top: top).as_null_object }
    let(:shape) { Shoes::Swt::Star.new dsl, swt_app }
    subject { Shoes::Swt::Star::Painter.new shape }

    it_behaves_like "fill painter"
    it_behaves_like "stroke painter"

    it "fills star" do
      expect(gc).to receive(:fillPolygon)
      subject.paint_control(event)
    end

    it "draws star" do
      expect(gc).to receive(:drawPolygon)
      subject.paint_control(event)
    end
  end
end
