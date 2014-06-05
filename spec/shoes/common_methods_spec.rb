require 'spec_helper'

describe Shoes::CommonMethods do

  let(:test_object) {double 'Tester', parent: parent, gui: gui}
  let(:parent) {double 'parent', add_child: true, remove_child: true}
  let(:gui) {double 'gui', clear: true}

  before :each do
    test_object.extend Shoes::CommonMethods
  end

  subject {test_object}

  describe '#remove' do

    before :each do
      subject.remove
    end

    it 'calls removes itself from the parent' do
      expect(parent).to have_received(:remove_child).with(subject)
    end

    it 'calls clear on the gui' do
      expect(gui).to have_received(:clear)
    end

    describe 'if the gui does not respond to clear' do
      # need to stub clear and respond_to because we get a non stubbed method otherwise
      # on our spie when verifying...
      let(:gui) {double 'no clear gui', clear: true, respond_to?: false}

      it 'does not call clear on the gui' do
        expect(gui).not_to have_received(:clear)
      end
    end
  end
end