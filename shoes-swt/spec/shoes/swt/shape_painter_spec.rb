# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Swt::ShapePainter do
  include_context "swt app"
  include_context "painter context"

  let(:dsl) do
    double("Shoes::Shape", parent: parent, hidden: false,
                           needs_rotate?: false, style: {}).as_null_object
  end

  let(:shape) { Shoes::Swt::Shape.new(dsl, swt_app) }
  subject { Shoes::Swt::ShapePainter.new(shape) }

  it_behaves_like "stroke painter"
  it_behaves_like "fill painter"
  it_behaves_like "movable painter"

  it "fills path" do
    expect(gc).to receive(:fill_path)
    subject.paint_control(event)
  end

  it "draws path" do
    expect(gc).to receive(:draw_path)
    subject.paint_control(event)
  end

  it "remembers scrolling position applied" do
    expect(shape.scroll_top_applied).to eq(nil)

    allow(parent).to receive(:scroll_top).and_return(10)
    subject.paint_control(event)

    expect(shape.scroll_top_applied).to eq(10)
  end
end
