# frozen_string_literal: true
require 'spec_helper'

describe Shoes::StandardLogger do
  subject(:logger) { Shoes::StandardLogger.new logdevice }
  let(:logdevice)  { StringIO.new }

  it "logs messages with format 'LEVEL: Message'" do
    logger.info "Message"
    expect(logdevice.string).to eq("INFO: Message\n")
  end

  it "defaults to STDERR" do
    allow(STDERR).to receive(:write)
    logger = Shoes::StandardLogger.new
    logger.error "Message"
    expect(STDERR).to have_received(:write)
  end
end
