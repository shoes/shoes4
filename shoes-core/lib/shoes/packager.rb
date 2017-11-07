# frozen_string_literal: true

class Shoes
  class Packager
    attr_reader :backend

    def initialize
      @backend = Shoes.backend_for(self)
      configure_gems
    rescue ArgumentError
      # Packaging unsupported by this backend
    end

    def options
      @backend.options
    end

    def parse!(args)
      options.parse!(args)
    end

    def run(path)
      raise "Packaging unsupported by this backend" if @backend.nil?
      @backend.run(path)
    end

    def configure_gems
      @backend.gems = []
      return unless defined?(::Bundler)

      @backend.gems = ::Bundler.environment.specs.map(&:name) - ["shoes"]
    rescue Bundler::GemfileNotFound
      # Ok to be quiet since we didn't even have a Gemfile
    rescue => e
      Shoes.logger.error "Looking up gems for packaging failed:\n#{e.message}"
    end
  end
end
