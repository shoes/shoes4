require 'spec_helper'

describe Shoes::Common::Remove do

  let(:parent) {double 'parent', add_child: true, remove_child: true}
  let(:gui) {double 'gui', remove: true}
  let(:test_class) {Class.new {include Shoes::Common::Remove}}

  subject {test_class.new}

  before :each do
    allow(subject).to receive_messages parent: parent, gui: gui
  end

  describe '#remove' do
    before :each do
      subject.remove
    end

    it 'calls removes itself from the parent' do
      expect(parent).to have_received(:remove_child).with(subject)
    end

    it 'calls remove on the gui' do
      expect(gui).to have_received(:remove)
    end

    describe 'if the gui does not respond to clear' do
      # need to stub clear and respond_to because we get a non stubbed method
      # otherwise on our spies when verifying...
      let(:gui) {double 'no clear gui', clear: true, respond_to?: false}

      it 'does not call clear on the gui' do
        expect(gui).not_to have_received(:clear)
      end
    end
  end
end
