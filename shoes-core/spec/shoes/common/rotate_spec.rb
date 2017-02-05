# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Common::Rotate do
  subject { test_class.new }

  describe '#needs_rotate?' do
    let(:test_class) do
      Class.new do
        attr_accessor :rotate
        include Shoes::Common::Rotate
      end
    end

    it 'is falsey if nil' do
      subject.rotate = nil
      expect(subject.needs_rotate?).to be_falsey
    end

    it 'is falsey if 0' do
      subject.rotate = 0
      expect(subject.needs_rotate?).to be_falsey
    end

    it 'is truthy if anything else' do
      subject.rotate = 42
      expect(subject.needs_rotate?).to be_truthy
    end
  end
end
