require 'swt_shoes/spec_helper'

describe Shoes::Swt::Line do
  let(:app) { double('app') }
  let(:opts) { {:app => app} }
  let(:dsl) { double('dsl').as_null_object }

  subject {
    Shoes::Swt::Line.new(dsl, opts)
  }

  context "#initialize" do
    before :each do
      app.should_receive(:add_paint_listener)
    end
    it { should be_instance_of(Shoes::Swt::Line) }
    its(:dsl) { should be(dsl) }
  end

  context "Swt-specific" do
    let(:paint_callback) { double("paint callback") }
    let(:opts) { {:app => app, :paint_callback => paint_callback} }

    it "uses passed-in paint callback if present" do
      app.should_receive(:add_paint_listener).with(paint_callback)
      subject
    end
  end

  it_behaves_like "paintable"

  describe "painter" do
    include_context "painter context"

    let(:left) { 25 }
    let(:top) { 77 }
    let(:width) { 130 }
    let(:height) { 400 }
    subject { Shoes::Swt::Line::Painter.new(shape) }

    it_behaves_like "stroke painter"

    specify "draws line" do
      gc.should_receive(:draw_line)
      subject.paint_control(event)
    end
  end
end
