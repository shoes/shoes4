require 'spec_helper'

describe Shoes, 'load_backend' do
  it "raises ArgumentError on bad input" do
    expect { Shoes.load_backend :bogus }.to raise_error
  end
end

describe Shoes, 'setup' do

  it 'knows this method' do
    expect(Shoes).to respond_to :setup
  end

  describe 'outputting on standard error' do

    def expect_stderr_puts(regex)
      expect($stderr).to receive(:puts).with(regex)
    end

    before :each do
      expect_stderr_puts(/WARN.+deprecated/)
    end

    it 'puts a warning message to $stderr' do
      Shoes.setup do end
    end

    it 'warns for individual gems' do
      expect_stderr_puts(/WARN.+foo.+gem install foo/)
      Shoes.setup do
        gem 'foo'
      end
    end

    it 'even reports the version number' do
      expect_stderr_puts(/gem install foo --version \"~>2.10.0\"/)
      Shoes.setup do
        gem 'foo ~>2.10.0'
      end
    end
  end

end
