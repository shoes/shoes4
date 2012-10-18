require 'swt_shoes/spec_helper'

describe Shoes::Swt::Line do
  let(:container) { double('container', :disposed? => false).as_null_object }
  let(:app) { double('app', :real => container, :add_paint_listener => true) }
  let(:dsl) { double('dsl', hidden: false).as_null_object }
  let(:point_a) { Shoes::Point.new(10, 100) }
  let(:point_b) { Shoes::Point.new(300, 10) }

  subject {
    Shoes::Swt::Line.new(dsl, app, point_a, point_b)
  }

  context "#initialize" do
    it { should be_instance_of(Shoes::Swt::Line) }
    its(:dsl) { should be(dsl) }

    specify "adds paint listener" do
      app.should_receive(:add_paint_listener)
      subject
    end
  end

  it_behaves_like "paintable"
  it_behaves_like "movable shape", 42, 52

  describe "painter" do
    include_context "painter context"

    let(:shape) { Shoes::Swt::Line.new(dsl, app, point_a, point_b) }
    subject { Shoes::Swt::Line::Painter.new(shape) }

    it_behaves_like "stroke painter"

    specify "draws line" do
      # coords as if drawn in box at (0,0)
      gc.should_receive(:draw_line).with(0, 90, 290, 0)
      subject.paint_control(event)
    end
  end
end
