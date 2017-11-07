# frozen_string_literal: true

require 'spec_helper'

describe Shoes::UI::CLI::HelpCommand do
  subject(:command) { Shoes::UI::CLI::HelpCommand.new }

  before do
    allow(command).to receive(:puts)
  end

  it "includes all subcommands" do
    Shoes::UI::CLI::SUPPORTED_COMMANDS.each_key do |key|
      expect(command).to receive(:puts).with(/shoes.*#{key}/)
    end

    command.run
  end

  it "warns on too many parameters" do
    expect(Shoes.logger).to receive(:warn).with(/Unexpected.*whatever/)

    command.args << "help" << "whatever"
    command.run
  end
end
