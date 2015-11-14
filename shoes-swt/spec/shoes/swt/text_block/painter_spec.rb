require 'spec_helper'

describe Shoes::Swt::TextBlock::Painter do
  include_context "swt app"

  let(:parent) { double("parent", absolute_left: 0, absolute_top: 0, height: 100, width: 200) }
  let(:dsl)    { double("dsl", app: shoes_app, gui: gui, parent: parent, hidden?: false) }
  let(:gui)    { double("gui", dispose: nil, segments: segment_collection) }
  let(:segment_collection) { double("segment collection", empty?: false) }

  let(:event)  { double("event", gc: graphics_context).as_null_object }
  let(:graphics_context) { double("graphics context", set_antialias: nil,
                                  set_line_cap: nil, set_transform: nil,
                                  get_clipping: nil, set_clipping: nil) }

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

  it "clips to parent" do
    expect(segment_collection).to receive(:paint_control)
    expect(graphics_context).to receive(:set_clipping).with(0, 0, 200, 100)
    subject.paintControl(event)
  end

  it "paints" do
    expect(segment_collection).to receive(:paint_control)
    subject.paintControl(event)
  end
end
