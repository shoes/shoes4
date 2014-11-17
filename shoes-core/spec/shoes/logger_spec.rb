require 'spec_helper'

describe Shoes::Logger do
  let(:awesome_logger) { Class.new }
  after { Shoes::Logger.unregister(:awesome_logger) }

  describe ".register" do
    it "allows new loggers to be registered" do
      Shoes::Logger.register(:awesome_logger, awesome_logger)
    end
  end

  describe ".get" do
    before { Shoes::Logger.register(:awesome_logger, awesome_logger) }

    it "retrieves a registered logger" do
      expect(Shoes::Logger.get(:awesome_logger)).to equal(awesome_logger)
    end
  end

  describe "default logger" do
    let(:logger) { Shoes.logger }

    it "is a ruby logger" do
      expect(logger).to be_an_instance_of(Shoes::Logger::Ruby)
    end
  end
end

describe Shoes::Logger::Ruby do
  let(:logdevice) { StringIO.new }
  subject(:logger) { Shoes::Logger::Ruby.new logdevice }

  it "logs messages with format 'LEVEL: Message'" do
    logger.info "Message"
    expect(logdevice.string).to eq("INFO: Message\n")
  end

  it "defaults to STDERR" do
    allow(STDERR).to receive(:write)
    logger = Shoes::Logger::Ruby.new
    logger.error "Message"
    expect(STDERR).to have_received(:write)
  end
end
