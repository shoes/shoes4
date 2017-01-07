require 'spec_helper'

describe Shoes::Swt::LinePainter do
  include_context "swt app"
  include_context "painter context"

  let(:dsl)  { Shoes::Line.new shoes_app, parent, left, top, 300, 10 }
  let(:left) { 10 }
  let(:top)  { 100 }

  let(:shape) { Shoes::Swt::Line.new(dsl, swt_app) }
  subject { Shoes::Swt::LinePainter.new(shape) }

  before(:each) do
    dsl.absolute_left = left
    dsl.absolute_top  = top
    allow(dsl).to receive_messages(positioned?: true)
  end

  it_behaves_like "stroke painter"

  specify "draws line" do
    expect(gc).to receive(:draw_line).with(10, 100, 300, 10)
    subject.paint_control(event)
  end
end
