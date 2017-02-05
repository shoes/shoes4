# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Swt::Background do
  include_context "swt app"

  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }
  let(:corners) { 0 }
  let(:fill) { Shoes::COLORS[:salmon] }
  let(:dsl) do
    double("dsl object", app: shoes_app,
                         element_left: left, element_top: top,
                         element_width: width, element_height: height,
                         translate_left: 0, translate_top: 0,
                         style: { strokewidth: 1 }, strokewidth: 1,
                         curve: corners, fill: fill,
                         hidden: false).as_null_object
  end

  subject { Shoes::Swt::Background.new dsl, swt_app }

  context "#initialize" do
    it { is_expected.to be_an_instance_of(Shoes::Swt::Background) }
    its(:dsl) { is_expected.to be(dsl) }
  end

  describe "#dispose" do
    let(:fill)     { double("fill", gui: fill_gui) }
    let(:fill_gui) { double("fill gui") }

    it "lets subresources go" do
      expect(fill_gui).to receive(:dispose)
      subject.dispose
    end
  end

  it_behaves_like "paintable"
  it_behaves_like "updating visibility"

  describe "painter" do
    include_context "painter context"

    let(:corners) { 0 }
    let(:shape) { Shoes::Swt::Background.new dsl, swt_app }
    subject { Shoes::Swt::Background::Painter.new shape }

    it_behaves_like "fill painter"

    describe "square corners" do
      let(:corners) { 0 }

      it "fills rect" do
        expect(gc).to receive(:fill_round_rectangle).with(left, top, width, height, corners * 2, corners * 2)
        subject.paint_control(event)
      end
    end

    describe "round corners" do
      let(:corners) { 13 }

      it "fills rect" do
        expect(gc).to receive(:fill_round_rectangle).with(left + 1, top + 1, width - 2, height - 2, corners * 2, corners * 2)
        subject.paint_control(event)
      end
    end
  end
end
