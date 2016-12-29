require 'spec_helper'

describe Shoes::Common::Rotate do
  subject { test_class.new }

  describe '#needs_rotate?' do
    let(:test_class) do
      Class.new do
        include Shoes::Common::Rotate

        def rotate
          45
        end
      end
    end

    it 'defaults to truthy value' do
      expect(subject.needs_rotate?).to be_truthy
    end
  end
end
