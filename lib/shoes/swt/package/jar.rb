require 'warbler'
require 'warbler/traits/shoes'

module Shoes
  module Swt
    module Package
      class Jar
        # @param [Shoes::Package::Configuration] config user configuration
        def initialize(config = nil)
          @shoes_config = config || ::Shoes::Package::Configuration.load
          Dir.chdir working_dir do
            @config = Warbler::Config.new do |config|
              config.jar_name = @shoes_config.shortname
              config.pathmaps.application = ['shoes-app/%p']
              specs = @shoes_config.gems.map { |g| Gem::Specification.find_by_name(g) }
              dependencies = specs.map { |s| s.runtime_dependencies }.flatten
              (specs + dependencies).uniq.each { |g| config.gems << g }
              ignore = @shoes_config.ignore.map do |f|
                path = f.to_s
                children = Dir.glob("#{path}/**/*") if File.directory?(path)
                [path, *children]
              end.flatten
              config.excludes.add FileList.new(ignore).pathmap(config.pathmaps.application.first)
            end
            @config.extend ShoesWarblerConfig
            @config.run = @shoes_config.run.split(/\s/).first
          end
        end

        def package(dir = default_dir)
          Dir.chdir working_dir do
            jar = Warbler::Jar.new
            jar.apply @config
            package_dir = dir.relative_path_from(working_dir)
            package_dir.mkpath
            path = package_dir.join(filename).to_s
            jar.create path
            File.expand_path path
          end
        end

        def default_dir
          working_dir.join 'pkg'
        end

        def filename
          "#{@config.jar_name}.#{@config.jar_extension}"
        end

        def working_dir
          @shoes_config.working_dir
        end

        private
        # Adds Shoes-specific functionality to the Warbler Config
        module ShoesWarblerConfig
          attr_accessor :run
        end
      end
    end
  end
end
