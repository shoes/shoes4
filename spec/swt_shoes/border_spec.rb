require 'swt_shoes/spec_helper'

describe Shoes::Swt::Border do
  include_context "swt app"

  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }
  let(:corners) { 0 }
  let(:dsl) { double("dsl object", element_width: width, element_height: height,
                     element_left: left, element_top: top, parent: parent,
                     strokewidth: 1, corners: corners,hidden: false).as_null_object }

  subject { Shoes::Swt::Border.new dsl, swt_app }

  context "#initialize" do
    it { should be_an_instance_of(Shoes::Swt::Border) }
    its(:dsl) { should be(dsl) }
  end

  it_behaves_like "paintable"

  describe "painter" do
    include_context "painter context"

    let(:corners) { 0 }
    let(:shape) { Shoes::Swt::Border.new dsl, swt_app }
    subject { Shoes::Swt::Border::Painter.new shape }

    it_behaves_like "stroke painter"

    describe "square corners" do
      let(:corners) { 0 }

      specify "draws rect" do
        gc.should_receive(:draw_round_rectangle).with(left+sw/2, top+sw/2, width-sw, height-sw, corners*2, corners*2)
        subject.paint_control(event)
      end
    end

    describe "round corners" do
      let(:corners) { 13 }

      specify "draws rect" do
        gc.should_receive(:draw_round_rectangle).with(left+sw/2, top+sw/2, width-sw, height-sw, corners*2, corners*2)
        subject.paint_control(event)
      end
    end
  end
end
