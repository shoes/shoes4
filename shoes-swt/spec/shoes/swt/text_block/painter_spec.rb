require 'spec_helper'

describe Shoes::Swt::TextBlock::Painter do
  include_context "swt app"

  let(:dsl)   { double("dsl", app: shoes_app, gui: gui, hidden?: false) }
  let(:gui)   { double("gui", dispose: nil, segments: segment_collection) }
  let(:event) { double("event").as_null_object }
  let(:segment_collection) { double("segment collection", empty?: false) }

  subject { Shoes::Swt::TextBlock::Painter.new(dsl) }

  it "doesn't draw if hidden" do
    allow(dsl).to receive(:hidden?) { true }
    expect(segment_collection).to_not receive(:paint_control)

    subject.paintControl(event)
  end

  it "doesn't draw no segment collection" do
    allow(gui).to receive(:segments) { nil }
    expect(segment_collection).to_not receive(:paint_control)

    subject.paintControl(event)
  end

  it "doesn't draw segment collection is empty" do
    allow(segment_collection).to receive(:empty?) { true }
    expect(segment_collection).to_not receive(:paint_control)

    subject.paintControl(event)
  end

  it "paints" do
    expect(segment_collection).to receive(:paint_control)
    subject.paintControl(event)
  end
end
