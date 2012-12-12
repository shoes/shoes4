require 'spec/shoes/spec_helper'
# NOTE: This spec is sadly circumventing the integration specs since we couldn't
# figure out how to get rid of the alert - it stopped the running tests

describe Shoes::Confirm do
  let(:app) { double('app', gui: true) }

  before :each do
    Shoes.configuration.stub(:backend_for)
    @confirm = Shoes::Confirm.new app, 'blaaa'
  end


  it 'can be easily created' do
    @confirm.should_not be_nil
  end

  it 'is not monkey patched on to object' do
    Object.new.respond_to?(:confirm).should be false
  end

  it 'responds to #confirmed?' do
    @confirm.should be_respond_to :confirmed?
  end

end