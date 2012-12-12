require 'spec/shoes/spec_helper'
# NOTE: This spec is sadly circumventing the integration specs since we couldn't
# figure out how to get rid of the alert - it stopped the running tests

describe Shoes::Dialog do
  let(:app) { double('app', gui: true) }

  before :each do
    Shoes.configuration.stub(backend_for: Shoes::Mock::Dialog.new)
    @dialog = Shoes::Dialog.new app
  end

  it 'is not nil' do
    @dialog.should_not be_nil
  end

  describe '#alert' do
    it 'returns nil' do
      @dialog.alert('something').should be_nil
    end
  end

  describe '#confirm' do
    it 'responds to it' do
      @dialog.should respond_to :confirm
    end

    it 'responds to the alias #confirm?' do
      @dialog.should respond_to :confirm?
    end
  end

  describe 'nothing monkey patched on to Object' do
    it 'is not monkey patched on to object' do
      Object.new.should_not respond_to :alert
    end

    it 'is not monkey patched on to object' do
      Object.new.should_not respond_to :confirm
    end
  end

end
