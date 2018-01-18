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
    let(:sample_message) { "sample message" }

    describe '#debug' do
      it 'must pass the given message as a debug message to #add_message' do
        console.debug(sample_message)
        console.drain_queued_messages
        expect(console.messages).to eq([[:debug, sample_message]])
      end
    end

    describe '#info' do
      it 'must pass the given message as a info message to #add_message' do
        console.info(sample_message)
        console.drain_queued_messages
        expect(console.messages).to eq([[:info, sample_message]])
      end
    end

    describe '#warn' do
      it 'must pass the given message as a warn message to #add_message' do
        console.warn(sample_message)
        console.drain_queued_messages
        expect(console.messages).to eq([[:warn, sample_message]])
      end
    end

    describe '#error' do
      it 'must pass the given message as a error message to #add_message' do
        console.error(sample_message)
        console.drain_queued_messages
        expect(console.messages).to eq([[:error, sample_message]])
      end
    end
  end

  describe "don't swamp with too many logs" do
    it "buffers a few at a time" do
      20.times { |i| console.error("whoa #{i}") }

      console.drain_queued_messages

      expected = 10.times.map { |i| [:error, "whoa #{i}"] }
      expect(console.messages).to eq(expected)
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
    after do
      begin
        File.delete(mock_dialog)
      rescue Errno::EACCES
        # AppVeyor doesn't allow deletions on all paths, so if it fails
        # Let it go, let it go, can't hold it back anymore!
        Shoes.logger.debug("Couldn't delete file #{mock_dialog}")
      end
    end

    it 'must create file with contents of @formatted_messages and return character count' do
      console.instance_variable_set(:@messages, sample_message_array.dup)
      console.create_app

      returned_character_count = console.save

      expect(returned_character_count).to eq(formatted_message_output.length)
      expect(File.open(mock_dialog, 'r').read).to eq(formatted_message_output)
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
