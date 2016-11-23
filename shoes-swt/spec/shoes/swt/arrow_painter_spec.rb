require 'spec_helper'

describe Shoes::Swt::ArrowPainter do
  include_context "painter context"

  let(:corners) { 0 }
  let(:app) { double('app', real: container, add_paint_listener: true, dsl: dsl) }
  let(:container) { double('container', disposed?: false) }

  let(:dsl) do
    double("dsl object", hidden: false, rotate: 0, left: left,
                         top: top, width: width, height: height,
                         style: {}, strokewidth: 1).as_null_object
  end

  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 222 }
  let(:shape) { Shoes::Swt::Arrow.new dsl, app }
  subject { Shoes::Swt::ArrowPainter.new shape }

  it_behaves_like "fill painter"
  it_behaves_like "stroke painter"

  it "draws on path" do
    expect(gc).to receive(:draw_path).with(subject.path)
    subject.paint_control(event)
  end

  it "fills on path" do
    expect(gc).to receive(:fill_path).with(subject.path)
    subject.paint_control(event)
  end
end
