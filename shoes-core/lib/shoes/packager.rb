# frozen_string_literal: true

class Shoes
  class Packager
    attr_reader :backend

    def initialize
      @backend = Shoes.backend_for(self)
      configure_gems
    rescue ArgumentError
      Shoes.logger.info "Packaging unsupported by this backend:\n#{e.message}"
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
      return
    rescue StandardError => e
      Shoes.logger.error "Looking up gems for packaging failed:\n#{e.message}"
    end
  end
end
