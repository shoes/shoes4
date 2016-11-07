require 'spec_helper'

describe Shoes::Common::Rotate do
  let(:test_class) { Class.new { include Shoes::Common::Rotate } }

  subject { test_class.new }

  describe '#needs_rotate?' do
    it 'defaults to falsey value' do
      expect(subject.needs_rotate?).to be_falsey
    end
  end
end
