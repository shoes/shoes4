require 'spec/shoes/spec_helper'
# NOTE: This spec is sadly circumventing the integration specs since we couldn't
# figure out how to get rid of the alert - it stopped the running tests

main_object = self

describe Shoes::Dialog do

  before :each do
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

  describe '#ask_open_file' do
    it 'responds to it' do
      @dialog.should respond_to :dialog_chooser
    end
  end

  describe '#ask_save_file' do
    it 'responds to it' do
      @dialog.should respond_to :dialog_chooser
    end
  end

  describe '#ask_open_folder' do
    it 'responds to it' do
      @dialog.should respond_to :dialog_chooser
    end
  end

  describe '#ask_save_folder' do
    it 'responds to it' do
      @dialog.should respond_to :dialog_chooser
    end
  end

  describe '#ask' do
    it 'responds to it' do
      @dialog.should respond_to :ask
    end
  end

  describe '#ask_color' do
    it 'responds to it' do
      @dialog.should respond_to :ask_color
    end
  end

  describe 'nothing monkey patched on to Object' do
    it 'is not monkey patched on to object' do
      Object.new.should_not respond_to :alert
    end

    it 'is not monkey patched on to object' do
      Object.new.should_not respond_to :confirm
    end

    it 'is not monkey patched on to object' do
      Object.new.should_not respond_to :dialog_chooser
    end

    it 'is not monkey patched on to object' do
      Object.new.should_not respond_to :ask
    end

    it 'is not monkey patched on to object' do
      Object.new.should_not respond_to :ask_color
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

    it 'knows of #ask_open_file' do
      main_object.should respond_to :ask_open_file
    end

    it 'knows of #ask_save_file' do
      main_object.should respond_to :ask_save_file
    end

    it 'knows of #ask_open_folder' do
      main_object.should respond_to :ask_open_folder
    end

    it 'knows of #ask_save_folder' do
      main_object.should respond_to :ask_save_folder
    end

    it 'knows of #ask' do
      main_object.should respond_to :ask
    end

    it 'knows of #ask' do
      main_object.should respond_to :ask_color
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

    it 'knows about #ask_open_file' do
      @app.should respond_to :ask_open_file
    end

    it 'knows about #ask_save_file' do
      @app.should respond_to :ask_save_file
    end

    it 'knows about #ask_open_folder' do
      @app.should respond_to :ask_open_folder
    end

    it 'knows about #ask_save_folder' do
      @app.should respond_to :ask_save_folder
    end

    it 'knows about #ask_save_folder' do
      @app.should respond_to :ask
    end

    it 'knows about #ask_save_color' do
      @app.should respond_to :ask_color
    end
  end

end
