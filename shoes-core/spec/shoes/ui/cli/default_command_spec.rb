# frozen_string_literal: true
require 'spec_helper'

describe Shoes::UI::CLI::DefaultCommand do
  subject(:command) { Shoes::UI::CLI::DefaultCommand.new }

  let(:stubbed_command) { double('stubbed command', run: nil) }

  before do
    # Keep from trying to run the file
    allow(command).to receive(:load)
    allow(command).to receive(:puts)

    allow(command.class).to receive(:exit)
  end

  it "loads a plain file" do
    command.args << "thing.rb"
    command.run

    expect(command).to have_received(:load).with("thing.rb")
  end

  it "allows known option" do
    command.args << "--fail-fast" << "thing.rb"
    command.run

    expect(Shoes.configuration.fail_fast).to eq(true)
    expect(command).to have_received(:load).with("thing.rb")
  end

  it "fails with error message" do
    expect(command).to receive(:puts).with(/Whoops/)
    expect(command).to_not receive(:load)

    command.args << "--unknown"
    command.run
  end

  it "warns on unexpected additional parameters" do
    expect(Shoes.logger).to receive(:warn).with(/Unexpected.*boo.rb/)
    expect(command).to receive(:load).with("thing.rb")

    command.args << "thing.rb" << "boo.rb"
    command.run
  end

  it "passes version through" do
    allow(Shoes::UI::CLI::VersionCommand).to receive(:new).and_return(stubbed_command)
    expect(stubbed_command).to receive(:run)
    expect(command).to receive(:exit)

    command.args << "-v"
    command.run
  end

  it "passes help through" do
    allow(Shoes::UI::CLI::HelpCommand).to receive(:new).and_return(stubbed_command)
    expect(stubbed_command).to receive(:run)
    expect(command).to receive(:exit)

    command.args << "-h"
    command.run
  end
end
