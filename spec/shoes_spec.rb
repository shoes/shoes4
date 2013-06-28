require 'spec_helper'

describe Shoes, 'load_backend' do
  it "raises ArgumentError on bad input" do
    expect { Shoes.load_backend :bogus }.to raise_error
  end
end
