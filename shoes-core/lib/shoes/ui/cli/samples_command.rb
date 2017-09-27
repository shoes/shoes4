# frozen_string_literal: true
require 'fileutils'
require 'shoes/samples'

class Shoes
  module UI
    class CLI
      class SamplesCommand < BaseCommand
        def run
          if parse!(args)
            source = Shoes::Samples.path
            destination = File.join((self.class.destination_dir || Dir.pwd), "shoes_samples")

            if File.exists?(destination)
              puts "Oops, #{destination} already exists! Try somewhere else, maybe with -d."
            else
              FileUtils.cp_r source, destination
            end
          end
        end

        class << self
          attr_accessor :destination_dir
        end

        def self.options
          OptionParser.new do |opts|
            opts.on('-dDEST', '--destination=DEST', 'Destination directory') do |destination|
              self.destination_dir = destination
            end
          end
        end

        def self.help
          help_from_options("shoes samples [options]",
                            self.options) + <<-EOS

    Installs samples to try out.
EOS
        end
      end
    end
  end
end
