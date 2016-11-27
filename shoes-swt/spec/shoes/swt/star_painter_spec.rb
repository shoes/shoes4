require 'spec_helper'

describe Shoes::Swt::StarPainter do
  include_context "swt app"
  include_context "painter context"

  let(:left) { 55 }
  let(:top) { 77 }
  let(:points) { 7 }
  let(:outer) { 100 }
  let(:inner) { 20 }
  let(:corners) { 0 }

  let(:dsl) do
    double("dsl object", hidden: false, points: points, outer: outer,
                         inner: inner, element_width: outer * 2.0,
                         element_height: outer * 2.0, element_left: left,
                         element_top: top).as_null_object
  end

  let(:shape) { Shoes::Swt::Star.new dsl, swt_app }
  subject { Shoes::Swt::StarPainter.new shape }

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
