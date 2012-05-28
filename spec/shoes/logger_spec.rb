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
      Shoes::Logger.get(:awesome_logger).should equal(awesome_logger)
    end
  end
end
