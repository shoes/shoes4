require 'spec_helper'

describe Shoes::Common::Style do

  class StyleTester
    include Shoes::Common::Style

    def initialize(style = {})
      @style = style
    end
  end

  subject {StyleTester.new}

  its(:style) {should eq Hash.new}

  describe 'changing the style trhough #style(hash)' do
    let(:changed_style) {{key: 'value'}}

    before :each do
      subject.style changed_style
    end

    it 'returns the changed style' do
      expect(subject.style).to eq changed_style
    end

    it 'does update values for new values' do
      subject.style new_key: 'new value'
      expect(subject.style[:new_key]).to eq 'new value'
    end

    # these specs are rather extensive as they are performance critical for
    # redrawing
    describe 'calling or not calling #update_style' do
      it 'does not call #update_style if no key value pairs changed' do
        expect(subject).not_to receive(:update_style)
        subject.style changed_style
      end

      it 'does not call #update_style if called without arg' do
        expect(subject).not_to receive(:update_style)
        subject.style
      end

      it 'does call #update_style if the values change' do
        expect(subject).to receive(:update_style)
        subject.style key: 'new value'
      end

      it 'does call #update_style if there is a new key-value' do
        expect(subject).to receive(:update_style)
        subject.style new_key: 'value'
      end
    end
  end

end
