# frozen_string_literal: true

require 'optparse'
require 'shoes'

require 'shoes/ui/cli/base_command'
require 'shoes/ui/cli/default_command'
require 'shoes/ui/cli/help_command'
require 'shoes/ui/cli/manual_command'
require 'shoes/ui/cli/package_command'
require 'shoes/ui/cli/samples_command'
require 'shoes/ui/cli/select_backend_command'
require 'shoes/ui/cli/version_command'

class Shoes
  module UI
    class CLI
      SUPPORTED_COMMANDS = {
        help:           HelpCommand,
        manual:         ManualCommand,
        package:        PackageCommand,
        samples:        SamplesCommand,
        select_backend: SelectBackendCommand,
        version:        VersionCommand,
      }.freeze

      def initialize(backend)
        $LOAD_PATH.unshift(Dir.pwd)
        backend_const = Shoes.load_backend(backend)
        backend_const.initialize_backend
      end

      def run(args)
        if args.empty?
          Shoes::UI::CLI::HelpCommand.new.run
          exit(1)
        end

        command = create_command(*args)
        command.run
      end

      def create_command(*args)
        command_class = SUPPORTED_COMMANDS[args.first.to_sym] || DefaultCommand
        command_class.new(*args.dup)
      end
    end
  end
end
