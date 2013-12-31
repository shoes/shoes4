require 'swt_shoes/spec_helper'

describe Shoes::Swt::Line do
  include_context "swt app"

  let(:container) { double('container', :disposed? => false).as_null_object }
  let(:dsl) { Shoes::Line.new shoes_app, parent, point_a, point_b }
  let(:point_a) { Shoes::Point.new(10, 100) }
  let(:point_b) { Shoes::Point.new(300, 10) }

  subject {
    Shoes::Swt::Line.new(dsl, swt_app)
  }

  context "#initialize" do
    it { should be_instance_of(Shoes::Swt::Line) }
    its(:dsl) { should be(dsl) }
  end

  it_behaves_like "paintable"
  it_behaves_like "togglable"

  describe "painter" do
    include_context "painter context"

    let(:shape) { Shoes::Swt::Line.new(dsl, swt_app) }
    subject { Shoes::Swt::Line::Painter.new(shape) }

    it_behaves_like "stroke painter"

    specify "draws line" do
      # coords as if drawn in box at (0,0)
      gc.should_receive(:draw_line).with(0, 90, 290, 0)
      subject.paint_control(event)
    end
  end
end
