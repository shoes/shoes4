require 'spec/shoes/spec_helper'

describe Shoes::Alert do
  let(:app) { Shoes::App.new }
  let(:opts) { Hash.new }

  it 'can be easily created' do
    alert = Shoes::Alert.new app, 'blaaa'
    alert.should_not be_nil
  end
end