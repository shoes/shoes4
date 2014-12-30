require 'pathname'
require 'yaml'
require 'furoshiki/configuration'
require 'furoshiki/validator'
require 'furoshiki/warbler_extensions'
require 'warbler/traits/shoes'

class Shoes
  module Package
    # Configuration for Shoes packagers.
    #
    # @example
    #   config_file = '/path/to/app.yaml'
    #   config = Shoes::Package::Configuration.load(config_file)
    #
    module Configuration
      extend ::Furoshiki::Util

      JAR_APP_TEMPLATE_URL = 'https://s3.amazonaws.com/net.wasnotrice.shoes/wrappers/shoes-app-template-0.0.1.zip'

      # Convenience method for loading config from a file. Note that you
      # can pass four kinds of paths to the loader. Given the following
      # file structure:
      #  
      #   ├── a
      #   │   ├── app.yaml
      #   │   └── shoes-app-a.rb
      #   └── b
      #   └── shoes-app-b.rb
      #
      # To package an app that has an `app.yaml`, like `shoes-app-a.rb`,
      # you can call the loader with any of:
      #
      # - a/app.yaml
      # - a
      # - a/shoes-app-a.rb
      #
      # These will all find and use your configuration in `a/app.yaml`.
      # To package an app that does not have an `app.yaml`, like
      # `b/shoes-app-b.rb`, you must call the loader with the path of
      # the script itself. Note that without an `app.yaml`, you will
      # only bundle a single file, and your app will simply use the
      # Shoes app icon.
      #
      # @overload load(path, base_config)
      #   @param [String] path location of the app's 'app.yaml'
      #   @param [Hash] base_config default values
      # @overload load(path)
      #   @param [String] path location of the directory that
      #      contains the app's 'app.yaml'
      #   @param [Hash] base_config default values
      # @overload load(path)
      #   @param [String] path location of the app
      #   @param [Hash] base_config default values
      def self.load(path, base_config = {})
        pathname = Pathname.new(path)
        app_yaml = Pathname.new('app.yaml')

        if pathname.basename == app_yaml
          file, dir = pathname, pathname.dirname
        elsif pathname.directory?
          file, dir = pathname.join(app_yaml), pathname
        elsif pathname.file? && pathname.parent.children.include?(pathname.parent.join app_yaml)
          file, dir = pathname.parent.join(app_yaml), pathname.parent
        else
          file, dir = config_for_single_file_app(pathname)
        end

        config = YAML.load(file.read)
        config[:working_dir] = dir
        config[:gems] = merge_gems(base_config, config)
        create(config)
      end

      # @param [Hash] config user options
      def self.create(config = {})
        defaults = {
          name: 'Shoes App',
          version: '0.0.0',
          release: 'Rookie',
          run: nil,
          ignore: 'pkg',
          # TODO: Add actual paths. Keep these keys for compatibility with Shoes 3
          icons: {
            #osx: 'path/to/default/App.icns',
            #gtk: 'path/to/default/app.png',
            #win32: 'path/to/default/App.ico',
          },
          # TODO: Add actual paths. Keep these keys for compatibility with Shoes 3
          dmg: {
            #ds_store: 'path/to/default/.DS_Store',
            #background: 'path/to/default/background.png'
          },
          working_dir: Dir.pwd,
          gems: ['shoes-core'],
          validator: Validator,
          warbler_extensions: WarblerExtensions
        }

        symbolized_config = deep_symbolize_keys(config)
        symbolized_config[:gems] = merge_gems(defaults, symbolized_config)
        Furoshiki::Configuration.new defaults.merge(symbolized_config)
      end

      private
      # If it exists, load default options. If not, let the filesystem raise an
      # error.
      def self.config_for_single_file_app(pathname)
        default_options = {
          run: pathname.basename.to_s,
          name: pathname.basename(pathname.extname).to_s.gsub(/\W/, '-')
        }.to_yaml
        options = pathname.exist? ? default_options : pathname
        dummy_file = Struct.new(:read)
        [dummy_file.new(options), pathname.parent]
      end

      # We want to retain all of the gems, but simply merging the hash will
      # replace the whole array, so we handle the gems separately. Note that
      # keys may not have been symbolized yet
      def self.merge_gems(base, additional)
        base_gems = base.fetch(:gems) rescue base['gems']
        additional_gems = additional.fetch(:gems) rescue additional['gems']
        Array(base_gems).concat(Array(additional_gems)).uniq
      end
    end

    class Validator < Furoshiki::Validator
      def validate
        unless config.run && config.working_dir.join(config.run).exist?
          add_missing_file_error(config.run, "Run file")
        end

        if config.icons[:osx] && !config.working_dir.join(config.icons[:osx]).exist?
          add_missing_file_error(config.icons[:osx], "OS X icon file")
        end
      end
    end

    class WarblerExtensions < Furoshiki::WarblerExtensions
      def customize(warbler_config)
        warbler_config.tap do |warbler|
          warbler.pathmaps.application = ['shoes-app/%p']
          warbler.extend ShoesWarblerConfig
          warbler.run = @config.run.split(/\s/).first
        end
      end

      private
      # Adds Shoes-specific functionality to the Warbler Config
      module ShoesWarblerConfig
        attr_accessor :run
      end
    end
  end
end
