require 'spec_helper'

describe Shoes::Swt::Common::Painter do
  let(:object) do
    double 'object', dsl: dsl, transform: transform, apply_fill: nil,
                     apply_stroke: nil
  end

  let(:parent) do
    double 'parent', absolute_left: 0, absolute_top: 0, width: 200, height: 100,
                     fixed_height?: true
  end

  let(:dsl) do
    double 'dsl', parent: parent, visible?: true, positioned?: true, style: {}
  end

  let(:event) { double 'paint event', gc: graphics_context }

  let(:graphics_context) do
    double 'graphics_context', dispose: nil,
                               clipping: nil,
                               set_clipping: nil,
                               set_antialias: nil,
                               set_line_cap: nil,
                               set_transform: nil,
                               setTransform: nil
  end

  let(:transform) { double 'transform', disposed?: false }

  subject { Shoes::Swt::Common::Painter.new object }

  before do
    allow(::Swt::Transform).to receive(:new) { transform }
  end

  describe '#paint_control' do
    it 'should attempts to paint the object' do
      expect(subject).to receive(:paint_object)
      subject.paint_control event
    end

    it 'does paint the object if it is hidden' do
      allow(dsl).to receive_messages visible?: false
      expect(subject).not_to receive(:paint_object)
      subject.paint_control event
    end

    it 'does not paint the object if it is not positioned' do
      allow(dsl).to receive_messages positioned?: false
      expect(subject).not_to receive(:paint_object)
      subject.paint_control event
    end

    it 'clips to parent region' do
      allow(dsl).to receive(:needs_rotate?) { false }
      expect(graphics_context).to receive(:set_clipping).with(0, 0, 200, 100)
      subject.paint_control event
    end

    it 'rotates' do
      allow(dsl).to receive(:needs_rotate?) { true }
      allow(dsl).to receive(:rotate) { 10 }
      allow(dsl).to receive(:element_left)   { 0 }
      allow(dsl).to receive(:element_width)  { 0 }
      allow(dsl).to receive(:element_top)    { 0 }
      allow(dsl).to receive(:element_height) { 0 }

      expect_transform_for_rotate

      subject.paint_control event
    end

    it "doesn't rotate if doesn't need it" do
      allow(dsl).to receive(:needs_rotate?) { false }

      expect(transform).not_to receive(:translate)
      expect(transform).not_to receive(:rotate)
      subject.paint_control event
    end
  end

  context "set_rotate" do
    it "disposes of transform" do
      expect_transform_for_rotate

      subject.set_rotate graphics_context, 0, 0, 0 do
        # no-op
      end
    end
  end

  def expect_transform_for_rotate
    expect(transform).to receive(:dispose)
    expect(transform).to receive(:translate).at_least(:once)
    expect(transform).to receive(:rotate).at_least(:once)
  end
end
