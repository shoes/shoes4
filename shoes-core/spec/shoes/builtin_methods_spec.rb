# frozen_string_literal: true
require 'spec_helper'

describe Shoes::BuiltinMethods do
  let(:input_blk) { proc {} }
  let(:app) { Shoes::App.new({}, &input_blk) }
  let(:logger) { double("logger") }
  let(:dialog) { double('dialog') }

  before :each do
    allow(Shoes).to receive(:logger) { logger }
  end

  describe 'Shoes.p' do
    it 'adds a debug to the log with an inspected object' do
      expect(Shoes.logger).to receive(:debug).with('message'.inspect)
      Shoes.p 'message'
    end

    it 'also handles object the way they should be handled' do
      expect(Shoes.logger).to receive(:debug).with('[]')
      Shoes.p []
    end
  end

  %w(info debug warn error).each do |level|
    describe "##{level}" do
      it 'sends to logger' do
        expect(Shoes.logger).to receive(level).with('test')
        app.public_send(level, "test")
      end
    end
  end

  %w(open_file save_file open_folder save_folder).each do |chooser_action|
    describe "#ask_#{chooser_action}" do
      before do
        allow(Shoes::Dialog).to receive(:new).and_return(dialog)
        expect(dialog).to receive(:dialog_chooser).and_return(dialog)
      end

      it 'creates a new chooser dialog' do
        expect(app.public_send("ask_#{chooser_action}")).to eq(dialog)
      end
    end
  end

  # just testing responds to things since the implementation is tested
  # elsewhere
  describe 'are builtin methods are also available from Shoes' do
    builtin_methods = [:alert, :ask, :ask_color, :ask_open_file, :ask_save_file,
                       :ask_open_folder, :ask_save_folder, :confirm, :color,
                       :debug, :error, :font, :gradient, :gray, :rgb, :info,
                       :pattern, :warn]

    builtin_methods.each do |method|
      it "responds to #{method}" do
        expect(Shoes).to respond_to method
      end
    end

    describe 'does not get to the nitty gritty helper_methods' do
      helper_methods = [:image_file?, :image_pattern]

      helper_methods.each do |method|
        it "does not respond to #{method}" do
          expect(Shoes).not_to respond_to method
        end
      end
    end
  end

  %w(alert confirm).each do |type|
    describe type do
      let(:message) { double('message') }

      before do
        allow(Shoes::Dialog).to receive(:new).and_return(dialog)
        expect(dialog).to receive(type).with(message).and_return(dialog)
      end

      it 'creates a new dialog' do
        expect(app.public_send(type, message)).to eq(dialog)
      end
    end
  end

  describe '#ask' do
    let(:message) { double('message') }
    let(:args) { double('args') }

    before do
      allow(Shoes::Dialog).to receive(:new).and_return(dialog)
      expect(dialog).to receive(:ask).with(message, args).and_return(dialog)
    end

    it 'creates a new dialog' do
      expect(app.ask(message, args)).to eq(dialog)
    end
  end

  describe '#ask_color' do
    let(:title) { double('title') }

    before do
      allow(Shoes::Dialog).to receive(:new).and_return(dialog)
      expect(dialog).to receive(:ask_color).with(title).and_return(dialog)
    end

    it 'creates a new dialog' do
      expect(app.ask_color(title)).to eq(dialog)
    end
  end
end
