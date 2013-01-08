require 'optparse'
require 'shoes'
require 'shoes/package'
require 'shoes/package/configuration'
require 'shoes/swt/package/app'

module Shoes
  class CLI
    def parse(args)
      options = Struct.new(:packages).new
      options.packages = []

      opts = OptionParser.new do |opts|
        opts.program_name = 'shoes'
        opts.banner = <<-EOS
  usage: #{opts.program_name} file
     or: #{opts.program_name} [-p package] file
        EOS
        opts.separator ''
        opts.separator 'Options:'

        opts.on('-p', '--package PACKAGE_TYPE', 'Package as BACKEND:PACKAGE') do |package|
          unless package =~ /^(swt):(app|jar)$/
            abort("#{opts.program_name}: Can't package as '#{package}'. See '#{opts.program_name} --help'")
          end
          options.packages << Package.new(package)
        end
        opts.separator "\nPackage types:"
        opts.separator package_types(opts)
        opts.separator "\nExamples:"
        opts.separator examples(opts)
      end

      opts.parse!(args)
      options
    end

    def package_types(opts)
      <<-EOS
      swt:app     A standalone OS X executable with the Swt backend
      swt:jar     An executable JAR with the Swt backend
      EOS
    end

    def examples(opts)
      <<-EOS
  To run a Shoes app:
      #{opts.program_name} path/to/shoes-app.rb

  Two ways to package a Shoes app as an APP and a JAR, using the Swt backend:
      #{opts.program_name} -p swt:app -p swt:jar path/to/app.yaml
      #{opts.program_name} -p swt:app -p swt:jar path/to/shoes-app.rb
      EOS
    end

    def package(path, packages = [])
      begin
        config = Shoes::Package::Configuration.load(path)
      rescue Errno::ENOENT => e
        abort "shoes: #{e.message}"
      end
      packages.each do |p|
        puts "Packaging #{p.backend}:#{p.wrapper}..."
        packager = Shoes::Package.new(p.backend, p.wrapper, config)
        packager.package
      end
    end

    # Execute a shoes app.
    #
    # @param [String] app the location of the app to run
    def execute_app(app)
      $LOAD_PATH.unshift(Dir.pwd)
      Shoes.configuration.backend = :swt
      load app
    end

    def run(args)
      options = parse(args)
      package(args.shift, options.packages) unless options.packages.empty?
      execute_app(args.first) unless args.empty?
    end

    # Convenience class representing a backend:wrapper pair
    class Package
      def initialize(arg)
        @backend, @wrapper = arg.split(':')
      end

      attr_reader :backend, :wrapper
    end
  end
end
