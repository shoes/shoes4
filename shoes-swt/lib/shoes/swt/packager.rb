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
          opts.on('--jar', 'Package as executable JAR file') do
            @packages << :jar
          end

          opts.on('--mac', 'Package as OS X application') do
            @packages << :mac
          end

          opts.on('--windows', 'Package as Windows application') do
            @packages << :windows
          end
        end
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

        @packages.each do |package_type|
          puts "Packaging #{package_type}..."
          packager = ::Shoes::Package.create_packager(config, package_type)
          packager.package
        end
      end
    end
  end
end
