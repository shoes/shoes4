require 'shoes/spec_helper'

describe Shoes::BuiltinMethods do
  let(:input_blk) { Proc.new {} }
  let(:app) { Shoes::App.new({}, &input_blk) }
  let(:logger) { double("logger") }

  before :each do
    Shoes::LOG.clear
    Shoes.stub(:logger) { logger }
  end

  describe 'Shoes.p' do
    it 'adds a debug to the log with an inspected object' do
      Shoes.p 'message'
      Shoes::LOG.should include ['debug', 'message'.inspect]
    end

    it 'also handles object the way they should be handled' do
      Shoes.p []
      Shoes::LOG.should include ['debug', '[]']
    end
  end

  describe "info" do
    before :each do
      logger.stub(:info)
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
      logger.stub(:debug)
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
      logger.stub(:warn)
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
      logger.stub(:error)
      app.error("test")
    end

    it "sets Shoes::LOG" do
      expect(Shoes::LOG).to eq([["error", "test"]])
    end

    it "sends message to logger" do
      expect(logger).to have_received(:error)
    end
  end
end
