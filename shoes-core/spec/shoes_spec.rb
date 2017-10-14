# frozen_string_literal: true

require 'spec_helper'

describe Shoes, 'load_backend' do
  it "raises on bad input" do
    expect { Shoes.load_backend :bogus }.to raise_error(LoadError)
  end
end

describe Shoes, 'setup' do
  it 'knows this method' do
    expect(Shoes).to respond_to :setup
  end

  describe 'outputting on standard error' do
    def expect_logger_warn(regex)
      expect(Shoes.logger).to receive(:warn).with(regex)
    end

    before :each do
      expect_logger_warn(/deprecated/)
    end

    it 'puts a warning message to $stderr' do
      Shoes.setup {}
    end

    it 'warns for individual gems' do
      expect_logger_warn(/foo.+gem install foo/)
      Shoes.setup do
        gem 'foo'
      end
    end

    it 'even reports the version number' do
      expect_logger_warn(/gem install foo --version \"~>2.10.0\"/)
      Shoes.setup do
        gem 'foo ~>2.10.0'
      end
    end
  end
end
