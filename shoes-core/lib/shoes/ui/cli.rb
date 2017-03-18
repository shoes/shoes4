# frozen_string_literal: true
require 'optparse'
require 'shoes'

class Shoes
  class CLI
    attr_reader :packager

    def initialize(backend)
      $LOAD_PATH.unshift(Dir.pwd)
      backend_const = Shoes.load_backend(backend)
      backend_const.initialize_backend

      @packager = Shoes::Packager.new
    end

    def parse!(args)
      options = OptionParser.new do |opts|
        opts.program_name = 'shoes'
        opts.banner = <<-EOS
Usage: #{opts.program_name} [-h] [-p package] file
        EOS
        opts.separator ''
        opts.separator 'Options:'

        opts.on('-p', '--package PACKAGE_TYPE', 'Package as BACKEND:PACKAGE') do |package|
          @packager.create_package(opts.program_name, package)
        end

        opts.on('-v', '--version', 'Shoes version') do
          puts "Shoes #{Shoes::Core::VERSION}"
          exit
        end

        opts.on('-m', '--manual', 'Run the Shoes manual') do
          require 'shoes/manual'
          Shoes::Manual.run "English"
          exit
        end

        opts.on('-b', '--backend [BACKEND]', 'Select a Shoes backend') do |backend|
          require 'shoes/ui/picker'
          Shoes::UI::Picker.new.run(ENV["SHOES_BIN_DIR"], backend)
          exit
        end

        opts.on('-f', '--fail-fast', 'Crash on exceptions in Shoes code') do
          Shoes.configuration.fail_fast = true
        end

        opts.separator @packager.help(opts.program_name)
      end

      options.parse!(args)
      options
    end

    # Execute a shoes app.
    #
    # @param [String] app the location of the app to run
    # @param [String] backend name of backend to load with the app
    def execute_app(app)
      load app
    end

    def run(args)
      opts = parse!(args)
      if args.empty?
        puts opts.banner
        puts "Try '#{opts.program_name} --help' for more information"
        exit(0)
      end

      if @packager.should_package?
        @packager.run(args.shift)
      else
        execute_app(args.first)
      end
    end
  end
end
