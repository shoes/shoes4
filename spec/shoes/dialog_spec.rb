require 'spec/shoes/spec_helper'
# NOTE: This spec is sadly circumventing the integration specs since we couldn't
# figure out how to get rid of the alert - it stopped the running tests

main_object = self

describe Shoes::Dialog do

  before :each do
    Shoes.configuration.stub(backend: Shoes::Mock)
    @dialog = Shoes::Dialog.new
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
  end

  describe 'nothing monkey patched on to Object' do
    it 'is not monkey patched on to object' do
      Object.new.should_not respond_to :alert
    end

    it 'is not monkey patched on to object' do
      Object.new.should_not respond_to :confirm
    end
  end

  describe 'the main object' do
    it 'knows of #alert' do
      main_object.should respond_to :alert
    end

    it 'knows of #confirm' do
      main_object.should respond_to :confirm
    end

    it 'knows of #confirm?' do
      main_object.should respond_to :confirm?
    end
  end

  describe 'Shoes::App' do
    before :each do
      @app = Shoes::App.new
    end

    it 'knows about #alert' do
      @app.should respond_to :alert
    end

    it 'knows about #confirm' do
      @app.should respond_to :confirm
    end
  end

end
