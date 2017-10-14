# frozen_string_literal: true

require 'fileutils'
require 'shoes/samples'

class Shoes
  module UI
    class CLI
      class SamplesCommand < BaseCommand
        attr_accessor :destination_dir

        def run
          if parse!(args)
            source = Shoes::Samples.path
            destination = File.join((destination_dir || Dir.pwd), "shoes_samples")

            if File.exist?(destination)
              puts "Oops, #{destination} already exists! Try somewhere else, maybe with -d."
            else
              FileUtils.cp_r source, destination
            end
          end
        end

        def options
          OptionParser.new do |opts|
            opts.on('-dDEST', '--destination=DEST', 'Destination directory') do |destination|
              self.destination_dir = destination
            end
          end
        end

        def help
          help_from_options("shoes samples [options]",
                            options) + <<-EOS

    Installs samples to try out.
EOS
        end
      end
    end
  end
end
