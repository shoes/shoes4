# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class DefaultCommand < BaseCommand
        def run
          if parse!(args)
            warn_on_unexpected_parameters

            path = args.first
            if path
              $LOAD_PATH.unshift(File.dirname(path))
              Shoes.configuration.app_dir = File.dirname(path)
              load path
            end
          end
        end

        def parse!(args)
          self.class.options.parse!(args)
          true
        rescue OptionParser::InvalidOption => e
          puts "Whoops! #{e.message}"
          puts
          puts self.class.help

          false
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

        def self.help
          help_from_options("shoes [options] file", options)
        end
      end
    end
  end
end
