require 'swt_shoes/spec_helper'

describe Shoes::Swt::Background do
  let(:container) { double('container', is_disposed?: false) }
  let(:gui) { double('gui', real: container) }
  let(:app) { double('app', real: container, gui: gui, add_paint_listener: true) }
  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }
  let(:corners) { 0 }
  let(:dsl) { double("dsl object", app: app, parent: parent,
                     element_left: left, element_top: top,
                     element_width: width, element_height: height,
                     absolute_left: left, absolute_top: top,
                     strokewidth: 1, corners: corners,
                     hidden: false).as_null_object }
  let(:parent) { double("parent", left: left, top: top,
                        absolute_left: left, absolute_top: top,
                        element_width: width, element_height: height,
                        contents: []) }

  subject {
    Shoes::Swt::Background.new dsl, app
  }

  context "#initialize" do
    it { should be_an_instance_of(Shoes::Swt::Background) }
    its(:dsl) { should be(dsl) }

    it "adds paint listener" do
      app.should_receive(:add_paint_listener)
      subject
    end
  end

  it_behaves_like "paintable"
  it_behaves_like "togglable"

  describe "painter" do
    include_context "painter context"

    let(:corners) { 0 }
    let(:shape) { Shoes::Swt::Background.new dsl, app}
    subject { Shoes::Swt::Background::Painter.new shape }

    it_behaves_like "fill painter"

    describe "square corners" do
      let(:corners) { 0 }

      it "fills rect" do
        gc.should_receive(:fill_round_rectangle).with(left, top, width, height, corners*2, corners*2)
        subject.paint_control(event)
      end
    end

    describe "round corners" do
      let(:corners) { 13 }

      it "fills rect" do
        gc.should_receive(:fill_round_rectangle).with(left, top, width, height, corners*2, corners*2)
        subject.paint_control(event)
      end
    end
  end
end
