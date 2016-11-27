require 'spec_helper'

describe Shoes::Common::Translate do
  let(:test_class) do
    Class.new do
      include Shoes::Common::Translate

      attr_reader :style
      def initialize(translate)
        @style = { translate: translate }
      end
    end
  end

  it 'allows nil' do
    subject = test_class.new(nil)
    expect(subject.translate_left).to eq(0)
    expect(subject.translate_top).to eq(0)
    expect(subject.translate).to be_nil
  end

  it 'sets values' do
    subject = test_class.new([10, 20])
    expect(subject.translate_left).to eq(10)
    expect(subject.translate_top).to eq(20)
    expect(subject.translate).to eq([10, 20])
  end
end
