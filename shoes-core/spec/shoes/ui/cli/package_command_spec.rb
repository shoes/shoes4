# frozen_string_literal: true
require 'spec_helper'

describe Shoes::UI::CLI::PackageCommand do
  subject(:command) { Shoes::UI::CLI::PackageCommand.new }

  let(:packager) { double("packager", parse!: nil, options: options, run: nil) }
  let(:options)  { double("options", summarize: ["summary"]) }

  before do
    allow(command).to receive(:puts)
    allow(Shoes::Packager).to receive(:new).and_return(packager)
  end

  it "runs" do
    expect(packager).to receive(:run).with("app.rb")

    command.args << "package" << "app.rb"
    command.run
  end

  it "fails with error message" do
    expect(command).to receive(:puts).with(/Whoops/)
    expect(command).to_not receive(:load)

    allow(packager).to receive(:parse!).and_raise(OptionParser::InvalidOption)
    command.run
  end

  it "warns on unexpected stuff" do
    expect(Shoes.logger).to receive(:warn).with(/Unexpected.*another.rb/)

    command.args << "package" << "app.rb" << "another.rb"
    command.run
  end
end
