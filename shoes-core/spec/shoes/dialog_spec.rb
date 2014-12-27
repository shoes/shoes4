require 'shoes/spec_helper'
# NOTE: This spec is sadly circumventing the integration specs since we couldn't
# figure out how to get rid of the alert - it stopped the running tests

main_object = self

describe Shoes::Dialog do

  before :each do
    @dialog = Shoes::Dialog.new
  end

  it 'is not nil' do
    expect(@dialog).not_to be_nil
  end

  describe '#alert' do
    it 'returns nil' do
      expect(@dialog.alert('something')).to be_nil
    end
  end

  describe '#confirm' do
    it 'responds to it' do
      expect(@dialog).to respond_to :confirm
    end
  end

  describe '#ask_open_file' do
    it 'responds to it' do
      expect(@dialog).to respond_to :dialog_chooser
    end
  end

  describe '#ask_save_file' do
    it 'responds to it' do
      expect(@dialog).to respond_to :dialog_chooser
    end
  end

  describe '#ask_open_folder' do
    it 'responds to it' do
      expect(@dialog).to respond_to :dialog_chooser
    end
  end

  describe '#ask_save_folder' do
    it 'responds to it' do
      expect(@dialog).to respond_to :dialog_chooser
    end
  end

  describe '#ask' do
    it 'responds to it' do
      expect(@dialog).to respond_to :ask
    end

    it 'runs ask dialog' do
      # Prevent the backend from actually running by stubbing out this method
      allow_any_instance_of(Shoes.backend::App).to receive(:wait_until_closed)

      result = @dialog.ask("What?", {})
      expect(result).to be_nil
    end
  end

  describe '#ask_color' do
    it 'responds to it' do
      expect(@dialog).to respond_to :ask_color
    end
  end

  describe 'nothing monkey patched on to Object' do
    it 'is not monkey patched on to object' do
      expect(Object.new).not_to respond_to :alert
    end

    it 'is not monkey patched on to object' do
      expect(Object.new).not_to respond_to :confirm
    end

    it 'is not monkey patched on to object' do
      expect(Object.new).not_to respond_to :dialog_chooser
    end

    it 'is not monkey patched on to object' do
      expect(Object.new).not_to respond_to :ask
    end

    it 'is not monkey patched on to object' do
      expect(Object.new).not_to respond_to :ask_color
    end
  end

  describe 'the main object' do
    it 'knows of #alert' do
      expect(main_object).to respond_to :alert
    end

    it 'knows of #confirm' do
      expect(main_object).to respond_to :confirm
    end

    it 'knows of #confirm?' do
      expect(main_object).to respond_to :confirm?
    end

    it 'knows of #ask_open_file' do
      expect(main_object).to respond_to :ask_open_file
    end

    it 'knows of #ask_save_file' do
      expect(main_object).to respond_to :ask_save_file
    end

    it 'knows of #ask_open_folder' do
      expect(main_object).to respond_to :ask_open_folder
    end

    it 'knows of #ask_save_folder' do
      expect(main_object).to respond_to :ask_save_folder
    end

    it 'knows of #ask' do
      expect(main_object).to respond_to :ask
    end

    it 'knows of #ask' do
      expect(main_object).to respond_to :ask_color
    end
  end

  describe 'Shoes::App' do
    before :each do
      @app = Shoes::App.new
    end

    it 'knows about #alert' do
      expect(@app).to respond_to :alert
    end

    it 'knows about #confirm' do
      expect(@app).to respond_to :confirm
    end

    it 'knows about #ask_open_file' do
      expect(@app).to respond_to :ask_open_file
    end

    it 'knows about #ask_save_file' do
      expect(@app).to respond_to :ask_save_file
    end

    it 'knows about #ask_open_folder' do
      expect(@app).to respond_to :ask_open_folder
    end

    it 'knows about #ask_save_folder' do
      expect(@app).to respond_to :ask_save_folder
    end

    it 'knows about #ask_save_folder' do
      expect(@app).to respond_to :ask
    end

    it 'knows about #ask_save_color' do
      expect(@app).to respond_to :ask_color
    end
  end

end
