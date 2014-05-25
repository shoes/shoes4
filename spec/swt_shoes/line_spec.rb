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
    it { is_expected.to be_instance_of(Shoes::Swt::Line) }
    its(:dsl) { is_expected.to be(dsl) }
  end

  it "properly disposes" do
    expect(subject.transform).to receive(:dispose)
    subject.dispose
  end

  it_behaves_like "paintable"
  it_behaves_like "togglable"

  it {is_expected.to respond_to :clear}

  describe "painter" do
    include_context "painter context"

    let(:shape) { Shoes::Swt::Line.new(dsl, swt_app) }
    subject { Shoes::Swt::Line::Painter.new(shape) }

    before(:each) do
      dsl.stub(positioned?: true)
    end

    it_behaves_like "stroke painter"

    specify "draws line" do
      # coords as if drawn in box at (0,0)
      gc.should_receive(:draw_line).with(0, 90, 290, 0)
      subject.paint_control(event)
    end
  end
end
