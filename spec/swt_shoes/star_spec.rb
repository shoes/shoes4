require 'swt_shoes/spec_helper'

describe Shoes::Swt::Star do
  let(:container) { double('container', :is_disposed? => false) }
  let(:gui) { double('gui', :real => container).as_null_object }
  let(:app) { double('app', :gui => gui).as_null_object }
  let(:left) { 55 }
  let(:top) { 77 }
  let(:points) { 7 }
  let(:outer) { 100 }
  let(:inner) { 20 }
  let(:dsl) { double("dsl object", hidden: false, points: points, outer: outer,
                     inner: inner, element_width: outer * 2.0,
                     element_height: outer * 2.0, element_left: left,
                     element_top: top).as_null_object }
  let(:real_dsl) { Shoes::Star.new app, left, top, points, outer, inner }

  subject { Shoes::Swt::Star.new real_dsl, app }

  context "#initialize" do
    its(:dsl) { should be(real_dsl) }

    it "adds paint listener" do
      app.should_receive(:add_paint_listener)
      subject
    end
  end

  it_behaves_like "paintable"
  it_behaves_like "togglable"
  it_behaves_like 'clickable backend'

  describe "painter" do
    include_context "painter context"

    let(:corners) { 0 }
    let(:shape) { Shoes::Swt::Star.new dsl, app }
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
