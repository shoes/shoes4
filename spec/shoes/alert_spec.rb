require 'spec/shoes/spec_helper'
# NOTE: This spec is sadly circumventing the integration specs since we couldn't
# figure out how to get rid of the alert - it stopped the running tests

main_object = self

describe Shoes::Alert do
  let(:app) { double('app', gui: true) }


  it 'can be easily created' do
    Shoes.configuration.stub(:backend_for)
    alert = Shoes::Alert.new app, 'blaaa'
    alert.should_not be_nil
  end

  it 'is not monkey patched on to object' do
    Object.new.respond_to?(:alert).should be false
  end

  it 'is known of by the main object' do
    main_object.respond_to?(:alert).should be true
  end
end