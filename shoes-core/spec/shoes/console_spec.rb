# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Console do
  # include_context 'dsl app'

  def call_button_mock_block(button_content)
    button_content.gui.instance_variable_get(:@mock_clickable_block).call
  end

  let(:console) { Shoes::Console.new }

  let(:sample_message_array) { [[:debug, 'debug message'], [:warn, 'warn message'], [:error, 'error message']] }
  let(:formatted_message_output) { "Debug\n debug message\n\nWarn\n warn message\n\nError\n error message\n\n" }

  let(:mock_dialog) { Shoes::Mock::Dialog.new.dialog_chooser }

  describe '#initialize' do
    it 'must reset @messages as []' do
      console.messages << 'placeholder'
      console.send(:initialize)
      expect(console.messages).to eq([])
    end
  end

  describe '#show' do
    let(:app) { Shoes.app }

    before(:each) do
      allow(console).to receive(:create_app) { :create_app_called }
      console.instance_variable_set(:@app, app)
    end

    context 'when app.open? is true' do
      it 'must call @app.focus' do
        allow(app).to receive(:open?) { true }
        expect(app).to receive(:focus)
        console.show
      end
    end

    context 'when #showing? is false' do
      it 'must call #create_app' do
        allow(app).to receive(:open?) { false }
        expect(console).to receive(:create_app)
        console.show
      end
    end
  end

  describe 'message type methods' do
    before(:each) { allow(console).to receive(:add_message) { |type, message| {type: type, message: message} } }

    describe '#debug' do
      it 'must pass the given message as a debug message to #add_message' do
        sample_message = 'test debugging message'
        expect(console.debug(sample_message)).to eq(type: :debug, message: sample_message)
      end
    end

    describe '#info' do
      it 'must pass the given message as a info message to #add_message' do
        sample_message = 'test info message'
        expect(console.info(sample_message)).to eq(type: :info, message: sample_message)
      end
    end

    describe '#warn' do
      it 'must pass the given message as a warn message to #add_message' do
        sample_message = 'test warning message'
        expect(console.warn(sample_message)).to eq(type: :warn, message: sample_message)
      end
    end

    describe '#error' do
      it 'must pass the given message as a error message to #add_message' do
        sample_message = 'test error message'
        expect(console.error(sample_message)).to eq(type: :error, message: sample_message)
      end
    end
  end

  describe '#add_message' do
    before(:each) do
      allow(console).to receive(:add_message_stack) { |type, message, index| {type: type, message: message, index: index} }
      console.instance_variable_set(:@messages, sample_message_array.dup)
    end

    it 'must add input to @messages and call #add_message_stack' do
      expect(console.add_message(:error, 'test error message')).to eq(type: :error, message: 'test error message', index: 3)
      expect(console.instance_variable_get(:@messages)).to eq(sample_message_array << [:error, 'test error message'])
    end
  end

  describe '#formatted_messages' do
    it 'must create string of messages formatted as they appear in console' do
      console.instance_variable_set(:@messages, sample_message_array.dup)

      expect(console.formatted_messages).to eq(formatted_message_output)
    end
  end

  describe '#copy' do
    context 'when @messages present' do
      it 'must set self.clipboard to @formatted_messages and return it' do
        console.instance_variable_set(:@messages, sample_message_array.dup)
        console.create_app

        expect(console.copy).to eq(formatted_message_output)
      end
    end

    context 'when @messages empty' do
      it 'must return nil' do
        console.instance_variable_set(:@messages, [])
        console.create_app

        expect(console.copy).to eq(nil)
      end
    end
  end

  describe '#save', no_swt: true do
    it 'must create file with contents of @formatted_messages and return character count' do
      console.instance_variable_set(:@messages, sample_message_array.dup)
      console.create_app

      returned_character_count = console.save

      expect(returned_character_count).to eq(formatted_message_output.length)
      expect(File.open(mock_dialog, 'r').read).to eq(formatted_message_output)
      File.delete(mock_dialog)
    end
  end

  describe '#clear' do
    it 'must clear @messages and @message_stacks' do
      console.instance_variable_set(:@messages, sample_message_array.dup)
      console.create_app

      console.clear

      expect(console.instance_variable_get(:@messages)).to eq([])
      expect(console.instance_variable_get(:@message_stacks)).to eq([])
    end
  end
end
