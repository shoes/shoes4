# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Console do
  # include_context 'dsl app'

  def call_button_mock_block(button_content)
    button_content.gui.instance_variable_get(:@mock_clickable_block).call
  end

  let(:console) { Shoes.console }

  let(:sample_message_array) { [[:debug, 'debug message'], [:warn, 'warn message'], [:error, 'error message']] }
  let(:formatted_message_output){ "Debug\n debug message\n\nWarn\n warn message\n\nError\n error message\n\n" }

  let(:mock_dialog) { Shoes::Mock::Dialog.new.dialog_chooser }

  before(:each) do
    # Depending on spec order, these can be leftover and contaminate other specs
    console.instance_variable_set(:@app, nil)
    console.instance_variable_set(:@messages, [])
  end

  describe '#initialize' do
    it 'must reset @messages as []' do
      console.instance_variable_set(:@messages, ['placeholder'])
      console.send(:initialize)
      expect(console.instance_variable_get(:@messages)).to eq([])
    end
  end

  describe '#show' do
    before(:each) do
      allow(console).to receive(:create_app) { :create_app_called }
      console.instance_variable_set(:@app, OpenStruct.new(focus: :app_focus_called))
    end

    context 'when #showing? is true' do
      before(:each) { allow(console).to receive(:showing?) { true } }

      it 'must call @app.focus' do
        expect(console.show).to eq(:app_focus_called)
      end
    end

    context 'when #showing? is false' do
      before(:each) { allow(console).to receive(:showing?) { false } }

      it 'must call @app.focus' do
        expect(console.show).to eq(:create_app_called)
      end
    end
  end

  describe '#create app' do
    let(:console_app) do
      console.instance_variable_set(:@messages, sample_message_array.dup)
      console.create_app
      console.instance_variable_get(:@app).instance_variable_get(:@__app__)
    end

    let(:console_app_nested_contents) { console_app.contents.first.contents.first.contents }

    context 'the contents ordering' do
      it 'must start with a background object' do
        expect(console_app_nested_contents.first.class).to eq(Shoes::Background)
      end

      it 'must have the second item be a stack' do
        expect(console_app_nested_contents[1].class).to eq(Shoes::Stack)
      end

      it 'must have the last three be button objects' do
        expect(console_app_nested_contents[2..4].map(&:class)).to eq([Shoes::Button, Shoes::Button, Shoes::Button])
      end
    end

    describe 'copy button' do
      context 'when @messages present' do
        it 'must set self.clipboard to @formatted_messages and return it' do
          returned = call_button_mock_block(console_app_nested_contents[2])

          expect(returned).to eq(formatted_message_output)
        end
      end

      context 'when @messages empty' do
        it 'must return nil' do
          console_app.app.instance_exec do
            append do
              @messages = []
            end
          end

          returned = call_button_mock_block(console_app_nested_contents[2])

          expect(returned).to eq(nil)
        end
      end
    end

    describe 'save button' do
      it 'must create file with contents of @formatted_messages and return character count' do
        returned_character_count = call_button_mock_block(console_app_nested_contents[3])

        expect(returned_character_count).to eq(formatted_message_output.length)
        expect(File.open(mock_dialog, 'r').read).to eq(formatted_message_output)
        File.delete(mock_dialog)
      end
    end

    describe 'clear button' do
      it 'must clear @messages and @message_stacks' do
        call_button_mock_block(console_app_nested_contents[4])

        expect(console.instance_variable_get(:@app).instance_variable_get(:@messages)).to eq([])
        expect(console.instance_variable_get(:@app).instance_variable_get(:@message_stacks)).to eq([])
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
end
