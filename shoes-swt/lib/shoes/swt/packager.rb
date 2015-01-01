class Shoes
  module Swt
    class Packager
      def initialize(dsl)
        @dsl = dsl
      end

      def create_package(program_name, package)
        unless package =~ /^(swt):(app|jar)$/
          abort("#{program_name}: Can't package as '#{package}'. See '#{program_name} --help'")
        end
        package.split(':')
      end

      def run(path)
        begin
          require 'shoes/package/configuration'
          require 'shoes/package/jar'
          require 'shoes/package/jar_app'
          master_config = ::Shoes::Package::Configuration.load(path)
        rescue Errno::ENOENT => e
          abort "shoes: #{e.message}"
        end

        @dsl.packages.each do |backend, wrapper|
          puts "Packaging #{backend}:#{wrapper}..."
          config = create_config(master_config, backend)
          packager = create_packager(config, wrapper)
          packager.package
        end
      end

      def help(program_name)
        <<-EOS

    Package types:
#{package_types}
    Examples:
#{examples(program_name)}
        EOS
      end

      def package_types()
        <<-EOS
    swt:app     A standalone OS X executable with the Swt backend
    swt:jar     An executable JAR with the Swt backend
        EOS
      end

      def examples(program_name)
        <<-EOS
    To run a Shoes app:
      #{program_name} path/to/shoes-app.rb

    Two ways to package a Shoes app as an APP and a JAR, using the Swt backend:
      #{program_name} -p swt:app -p swt:jar path/to/app.yaml
      #{program_name} -p swt:app -p swt:jar path/to/shoes-app.rb
          EOS
      end

      private
      # Copy the master config (including singleton class), since we may be
      # packaging for more than one backend
      def create_config(master_config, backend)
        config = master_config.clone
        config.gems << "shoes-#{backend}"
        config
      end

      def create_packager(config, wrapper)
        case wrapper
        when 'jar'
          ::Furoshiki::Jar.new(config)
        when 'app'
          ::Furoshiki::JarApp.new(config)
        else
          abort "shoes: Don't know how to make #{backend}:#{wrapper} packages"
        end
      end
    end
  end
end
