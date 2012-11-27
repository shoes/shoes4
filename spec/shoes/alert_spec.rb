require 'spec/shoes/spec_helper'
# NOTE: This spec is sadly circumventing the integration specs since we couldn't
# figure out how to get rid of the alert - it stopped the running tests

describe Shoes::Alert do
  let(:app) { double('app', gui: true) }


  it 'can be easily created' do
    Shoes.configuration.stub(:backend_for)
    alert = Shoes::Alert.new app, 'blaaa'
    alert.should_not be_nil
  end
end