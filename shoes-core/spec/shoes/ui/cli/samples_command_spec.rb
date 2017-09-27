# frozen_string_literal: true
require 'spec_helper'

describe Shoes::UI::CLI::SamplesCommand do
  subject(:command) { Shoes::UI::CLI::SamplesCommand.new([]) }

  let(:source_path) { "~/path/to/the/samples" }

  before do
    Shoes::UI::CLI::SamplesCommand.destination_dir = nil
    allow(Shoes::Samples).to receive(:path).and_return(source_path)
    allow(command).to receive(:puts)
  end

  it "copies to current directory" do
    expect(FileUtils).to receive(:cp_r).with(source_path, File.join(Dir.pwd, "shoes_samples"))
    command.run
  end

  it "copies to a specified directory from arguments" do
    expect(FileUtils).to receive(:cp_r).with(source_path, "~/somewhere/shoes_samples")
    command.args << "-d" << "~/somewhere"
    command.run
  end

  it "fails and warns if directory already exists" do
    allow(File).to receive(:exists?).and_return(true)
    expect(FileUtils).to_not receive(:cp_r).with(source_path, File.join(Dir.pwd, "shoes_samples"))
    command.run
  end
end
