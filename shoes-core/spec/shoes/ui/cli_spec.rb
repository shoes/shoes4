# frozen_string_literal: true
require 'spec_helper'

describe Shoes::UI::CLI do
  subject(:cli) { Shoes::UI::CLI.new(:mock) }

  ALL_COMMAND_CLASSES = [Shoes::UI::CLI::DefaultCommand] +
                        Shoes::UI::CLI::SUPPORTED_COMMANDS.map(&:last)

  it "recognizes help subcommand" do
    command = cli.create_command("help")
    expect(command).to be_an_instance_of(Shoes::UI::CLI::HelpCommand)
    expect(command.args).to eq(["help"])
  end

  it "recognizes manual subcommand" do
    command = cli.create_command("manual")
    expect(command).to be_an_instance_of(Shoes::UI::CLI::ManualCommand)
    expect(command.args).to eq(["manual"])
  end

  it "recognizes package subcommand" do
    command = cli.create_command("package", "something.rb")
    expect(command).to be_an_instance_of(Shoes::UI::CLI::PackageCommand)
    expect(command.args).to eq(["package", "something.rb"])
  end

  it "recognizes select_backend subcommand" do
    command = cli.create_command("select_backend", "backitup")
    expect(command).to be_an_instance_of(Shoes::UI::CLI::SelectBackendCommand)
    expect(command.args).to eq(["select_backend", "backitup"])
  end

  it "recognizes version subcommand" do
    command = cli.create_command("version")
    expect(command).to be_an_instance_of(Shoes::UI::CLI::VersionCommand)
    expect(command.args).to eq(["version"])
  end

  it "falls back to default run command otherwise" do
    command = cli.create_command("my_app.rb")
    expect(command).to be_an_instance_of(Shoes::UI::CLI::DefaultCommand)
    expect(command.args).to eq(["my_app.rb"])
  end

  describe "help" do
    ALL_COMMAND_CLASSES.each do |command_class|
      it "supports help for #{command_class}" do
        expect(command_class.help).to_not be_empty
      end
    end
  end
end
