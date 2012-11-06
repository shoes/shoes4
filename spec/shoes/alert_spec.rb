require 'spec/shoes/spec_helper'

describe Shoes::Alert do
  let(:app) { Shoes::App.new }


  it 'can be easily created' do
    alert = Shoes::Alert.new app, 'blaaa'
    # we never reach this since it waits for user input
    alert.should_not be_nil
  end
end