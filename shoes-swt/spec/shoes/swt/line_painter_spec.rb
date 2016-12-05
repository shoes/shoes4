require 'spec_helper'

describe Shoes::Swt::LinePainter do
  include_context "swt app"
  include_context "painter context"

  let(:dsl) { Shoes::Line.new shoes_app, parent, point_a, point_b }
  let(:point_a) { Shoes::Point.new(10, 100) }
  let(:point_b) { Shoes::Point.new(300, 10) }

  let(:shape) { Shoes::Swt::Line.new(dsl, swt_app) }
  subject { Shoes::Swt::LinePainter.new(shape) }

  before(:each) do
    dsl.absolute_left = point_a.x
    dsl.absolute_top  = point_a.y
    allow(dsl).to receive_messages(positioned?: true)
  end

  it_behaves_like "stroke painter"

  specify "draws line" do
    expect(gc).to receive(:draw_line).with(10, 100, 300, 10)
    subject.paint_control(event)
  end
end
