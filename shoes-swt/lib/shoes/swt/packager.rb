# frozen_string_literal: true
class Shoes
  module Swt
    class Packager
      attr_accessor :gems

      def initialize(dsl)
        @dsl  = dsl
        @gems = []
        @packages = []
      end

      def options
        OptionParser.new do |opts|
          opts.on('-p', '--package PACKAGE_TYPE', 'Package as BACKEND:PACKAGE') do |package|
            @packages << create_package("shoes", package)
          end
        end
      end

      def create_package(program_name, package)
        unless package =~ /^(swt):(app|jar)$/
          abort("#{program_name}: Can't package as '#{package}'. See '#{program_name} --help'")
        end
        package.split(':')
      end

      def run(path)
        begin
          require 'shoes/package'
          require 'shoes/package/configuration'
          config = ::Shoes::Package::Configuration.load(path)
          config.gems.concat(@gems)
        rescue Errno::ENOENT => e
          abort "shoes: #{e.message}"
        end

        @packages.each do |backend, wrapper|
          puts "Packaging #{backend}:#{wrapper}..."
          packager = ::Shoes::Package.create_packager(config, wrapper)
          packager.package
        end
      end
    end
  end
end
