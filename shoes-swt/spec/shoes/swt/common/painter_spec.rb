require 'shoes/swt/spec_helper'

describe Shoes::Swt::Common::Painter do
  let(:object) {double 'object', dsl: dsl}
  let(:dsl) {double 'dsl', visible?: true, positioned?: true}
  let(:event) {double 'paint event', gc: graphics_context}
  let(:graphics_context) { double 'graphics_context',
                                  set_antialias: nil, set_line_cap: nil,
                                  set_transform: nil, setTransform: nil }
  let(:transform) { double 'transform', disposed?: false }
  subject {Shoes::Swt::Common::Painter.new object}

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

  end

  context "set_rotate" do
    it "disposes of transform" do
      expect(transform).to receive(:dispose)
      expect(transform).to receive(:translate).at_least(:once)
      expect(transform).to receive(:rotate).at_least(:once)

      subject.set_rotate graphics_context, 0, 0, 0 do
        #no-op
      end
    end
  end

end
