# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Swt::Slot do
  include_context "swt app"

  let(:dsl) do
    instance_double Shoes::Slot, hidden?: true, visible?: false,
                                 contents: [content]
  end

  let(:content) { double 'content', show: true, hide: true }

  subject { Shoes::Swt::Slot.new dsl, swt_app }

  describe '#remove' do
    it 'cleans up click listeners' do
      expect(swt_app.click_listener).to receive(:remove_listeners_for).with(dsl)
      subject.remove
    end
  end
end
