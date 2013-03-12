require 'swt_shoes/spec_helper'

describe Shoes::Swt::Star do
  let(:container) { double('container', :disposed? => false) }
  let(:app) { double('app', :real => container, :add_paint_listener => true) }
  let(:left) { 55 }
  let(:top) { 77 }
  let(:points) { 7 }
  let(:outer) { 100 }
  let(:inner) { 20 }
  let(:dsl) { double("dsl object", hidden: false).as_null_object }

  subject {
    Shoes::Swt::Star.new dsl, app, left, top, points, outer, inner
  }

  context "#initialize" do
    it { should be_an_instance_of(Shoes::Swt::Star) }
    its(:dsl) { should be(dsl) }

    it "adds paint listener" do
      app.should_receive(:add_paint_listener)
      subject
    end
  end

  it_behaves_like "paintable"
  it_behaves_like "movable shape", 10, 20

  describe "painter" do
    include_context "painter context"

    let(:corners) { 0 }
    let(:shape) { Shoes::Swt::Star.new dsl, app, left, top, points, outer, inner }
    subject { Shoes::Swt::Star::Painter.new shape }

    it_behaves_like "fill painter"
    it_behaves_like "stroke painter"

    it "fills star" do
      gc.should_receive(:fillPolygon)
      subject.paint_control(event)
    end

    it "draws star" do
      gc.should_receive(:drawPolygon)
      subject.paint_control(event)
    end
  end
end
