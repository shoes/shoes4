# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Logger do
  describe "default logger" do
    subject(:logger) { Shoes::Logger.new }

    let(:logger1) { double('logger 1') }
    let(:logger2) { double('logger 2') }

    before do
      logger << logger1
      logger << logger2
    end

    it "dispatches to all loggers" do
      expect(logger1).to receive(:debug).with("DE-BUGS")
      expect(logger2).to receive(:debug).with("DE-BUGS")
      logger.debug("DE-BUGS")
    end

    it "chains appending" do
      result = logger << double('another')
      expect(result).to eq(logger)
    end
  end
end

describe Shoes::Logger::StandardLogger do
  let(:logdevice) { StringIO.new }
  subject(:logger) { Shoes::Logger::StandardLogger.new logdevice }

  it "logs messages with format 'LEVEL: Message'" do
    logger.info "Message"
    expect(logdevice.string).to eq("INFO: Message\n")
  end

  it "defaults to STDERR" do
    allow(STDERR).to receive(:write)
    logger = Shoes::Logger::StandardLogger.new
    logger.error "Message"
    expect(STDERR).to have_received(:write)
  end
end
