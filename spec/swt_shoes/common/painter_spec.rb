require 'swt_shoes/spec_helper'

describe Shoes::Swt::Common::Painter do
  let(:object) {double 'object', dsl: dsl}
  let(:dsl) {double 'dsl', visible?: true, positioned?: true}
  let(:event) {double 'paint event', gc: graphics_context}
  let(:graphics_context) {double 'graphics_context'}
  subject {Shoes::Swt::Common::Painter.new object}

  describe '#paint_control' do
    it 'should attempts to paint the object' do
      expect(subject).to receive(:paint_object)
      subject.paint_control event
    end

    it 'does paint the object if it is hidden' do
      dsl.stub visible?: false
      expect(subject).not_to receive(:paint_object)
      subject.paint_control event
    end

    it 'does not paint the object if it is not positioned' do
      dsl.stub positioned?: false
      expect(subject).not_to receive(:paint_object)
      subject.paint_control event
    end
  end

end