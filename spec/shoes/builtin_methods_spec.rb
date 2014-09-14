require 'shoes/spec_helper'

describe Shoes::BuiltinMethods do
  let(:input_blk) { Proc.new {} }
  let(:app) { Shoes::App.new({}, &input_blk) }
  let(:logger) { double("logger") }

  before :each do
    Shoes::LOG.clear
    allow(Shoes).to receive(:logger) { logger }
  end

  describe 'Shoes.p' do
    it 'adds a debug to the log with an inspected object' do
      Shoes.p 'message'
      expect(Shoes::LOG).to include ['debug', 'message'.inspect]
    end

    it 'also handles object the way they should be handled' do
      Shoes.p []
      expect(Shoes::LOG).to include ['debug', '[]']
    end
  end

  describe "info" do
    before :each do
      allow(logger).to receive(:info)
      app.info("test")
    end

    it "sets Shoes::LOG" do
      expect(Shoes::LOG).to eq([["info", "test"]])
    end

    it "sends message to logger" do
      expect(logger).to have_received(:info)
    end
  end

  describe "debug" do
    before :each do
      allow(logger).to receive(:debug)
      app.debug("test")
    end

    it "sets Shoes::LOG" do
      expect(Shoes::LOG).to eq([["debug", "test"]])
    end

    it "sends message to logger" do
      expect(logger).to have_received(:debug)
    end
  end

  describe "warn" do
    before :each do
      allow(logger).to receive(:warn)
      app.warn("test")
    end

    it "sets Shoes::LOG" do
      expect(Shoes::LOG).to eq([["warn", "test"]])
    end

    it "sends message to logger" do
      expect(logger).to have_received(:warn)
    end
  end

  describe "error" do
    before :each do
      allow(logger).to receive(:error)
      app.error("test")
    end

    it "sets Shoes::LOG" do
      expect(Shoes::LOG).to eq([["error", "test"]])
    end

    it "sends message to logger" do
      expect(logger).to have_received(:error)
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
end
