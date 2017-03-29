# frozen_string_literal: true
require 'spec_helper'

describe Shoes::UI::CLI::PackageCommand do
  subject(:command) { Shoes::UI::CLI::PackageCommand.new([]) }

  let(:packager) { double("packager", parse!: nil, run: nil) }

  before do
    allow(Shoes::Packager).to receive(:new).and_return(packager)
  end

  it "runs" do
    expect(packager).to receive(:run).with("app.rb")

    command.args << "package" << "app.rb"
    command.run
  end

  it "warns on unexpected stuff" do
    expect(Shoes.logger).to receive(:warn).with(/Unexpected.*another.rb/)

    command.args << "package" << "app.rb" << "another.rb"
    command.run
  end
end
