# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Swt::OvalPainter do
  include_context "swt app"
  include_context "painter context"

  subject { Shoes::Swt::OvalPainter.new(shape) }

  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:dsl) { ::Shoes::Oval.new shoes_app, parent, left, top, width, height }
  let(:shape) { Shoes::Swt::Oval.new(dsl, swt_app) }

  before :each do
    shape.absolute_left = left
    shape.absolute_top  = top
  end

  it_behaves_like "fill painter"
  it_behaves_like "stroke painter"

  it "creates oval clipping area" do
    double_path = double("path")
    allow(::Swt::Path).to receive(:new) { double_path }
    expect(double_path).to receive(:add_arc).with(left, top, width, height, 0, 360)
    subject.clipping
  end

  it "fills" do
    expect(gc).to receive(:fill_oval)
    subject.paint_control(event)
  end

  specify "draws oval" do
    expect(gc).to receive(:draw_oval).with(left + sw / 2, top + sw / 2, width - sw, height - sw)
    subject.paint_control(event)
  end
end
