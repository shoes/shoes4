require 'optparse'
require 'shoes'

class Shoes
  class CLI
    def initialize
      @packages = []
    end

    def parse!(args)
      opts = OptionParser.new do |opts|
        opts.program_name = 'shoes'
        opts.banner = <<-EOS
Usage: #{opts.program_name} [-h] [-p package] file
        EOS
        opts.separator ''
        opts.separator 'Options:'

        opts.on('-p', '--package PACKAGE_TYPE', 'Package as BACKEND:PACKAGE') do |package|
          unless package =~ /^(swt):(app|jar)$/
            abort("#{opts.program_name}: Can't package as '#{package}'. See '#{opts.program_name} --help'")
          end
          @packages << Package.new(package)
        end

        opts.on('-v', '--version', 'Shoes version') do
          puts "Shoes #{VERSION}"
          exit
        end

        opts.separator "\nPackage types:"
        opts.separator package_types(opts)
        opts.separator "\nExamples:"
        opts.separator examples(opts)
      end

      opts.parse!(args)
      opts
    end

    def package_types(_opts)
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

    def package(path)
      begin
        require 'furoshiki/shoes'
        config = Furoshiki::Shoes::Configuration.load(path)
      rescue Errno::ENOENT => e
        abort "shoes: #{e.message}"
      end
      @packages.each do |p|
        puts "Packaging #{p.backend}:#{p.wrapper}..."
        packager = Furoshiki::Shoes.new(p.backend, p.wrapper, config)
        packager.package
      end
    end

    # Execute a shoes app.
    #
    # @param [String] app the location of the app to run
    def execute_app(app)
      $LOAD_PATH.unshift(Dir.pwd)
      require 'shoes/swt'
      load app
    end

    def run(args)
      opts = parse!(args)
      if args.empty?
        puts opts.banner
        puts "Try '#{opts.program_name} --help' for more information"
        exit(0)
      end
      package(args.shift) unless @packages.empty?
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
