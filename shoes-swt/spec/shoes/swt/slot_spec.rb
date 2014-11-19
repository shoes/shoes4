require 'shoes/swt/spec_helper'

describe Shoes::Swt::Slot do
  include_context "swt app"
  let(:dsl) {instance_double Shoes::Slot, hidden?: true,
                             visible?: false, contents: [content] }
  let(:content) {double 'content', show: true, hide: true}

  subject {Shoes::Swt::Slot.new dsl, swt_app}

  describe '#update_visibility' do
    it 'does not set visibility on the parent #904' do
      subject.update_visibility
      expect(swt_app.real).not_to have_received(:set_visible)
    end

    # spec may be deleted if we can hide slots as a whole and not each element
    # on its own
    it 'tries to hide the content' do
      subject.update_visibility
      expect(content).to have_received :hide
    end
  end
end