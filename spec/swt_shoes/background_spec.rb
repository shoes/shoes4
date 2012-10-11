require 'swt_shoes/spec_helper'

describe Shoes::Swt::Background do
  let(:container) { double('container', :disposed? => false) }
  let(:app) { double('app', :real => container, :add_paint_listener => true) }
  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }
  let(:dsl) { double("dsl object", width: width, height: height, parent: parent, strokewidth: 1) }
  let(:parent) { double("parent", width: width, height: height, left: left, top: top) }

  subject {
    Shoes::Swt::Background.new dsl, app, left, top, width, height
  }

  context "#initialize" do
    it { should be_an_instance_of(Shoes::Swt::Background) }
    its(:dsl) { should be(dsl) }

    specify "adds paint listener" do
      app.should_receive(:add_paint_listener)
      subject
    end
  end

  it_behaves_like "paintable"

  describe "painter" do
    include_context "painter context"

    let(:corners) { 0 }
    let(:shape) { Shoes::Swt::Background.new dsl, app, left, top, width, height, :curve => corners }
    subject { Shoes::Swt::Background::Painter.new shape }

    it_behaves_like "fill painter"

    describe "square corners" do
      let(:corners) { 0 }

      specify "fills rect" do
        gc.should_receive(:fill_round_rectangle).with(left, top, width, height, corners, corners)
        subject.paint_control(event)
      end
    end

    describe "round corners" do
      let(:corners) { 13 }

      specify "fills rect" do
        gc.should_receive(:fill_round_rectangle).with(left, top, width, height, corners, corners)
        subject.paint_control(event)
      end
    end
  end
end
