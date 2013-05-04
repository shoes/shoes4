require 'spec_helper'

describe Shoes, 'load_backend' do
  it "raises ArgumentError on bad input" do
    lambda { Shoes.load_backend :bogus }
  end
end
