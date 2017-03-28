# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class DefaultCommand < BaseCommand
        def run
          options.parse!(args)
          load args.first
        end

        def self.help
          help_from_options("shoes [options] file", options)
        end

        def options
          self.class.options
        end

        def self.options
          OptionParser.new do |opts|
            # Keep around command dashed options
            opts.on('-v', '--version', 'Shoes version') do
              Shoes::UI::CLI::VersionCommand.new([]).run
              exit
            end

            opts.on('-h', '--help', 'Shoes help') do
              Shoes::UI::CLI::HelpCommand.new([]).run
              exit
            end

            # Also, we have some real runtime options!
            opts.on('-f', '--fail-fast', 'Crash on exceptions in Shoes code') do
              Shoes.configuration.fail_fast = true
            end
          end
        end
      end
    end
  end
end
