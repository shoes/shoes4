# frozen_string_literal: true
require 'spec_helper'

describe Shoes::LoggerCollection do
  subject(:logger) { Shoes::LoggerCollection.new }

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
