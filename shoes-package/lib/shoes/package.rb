# frozen_string_literal: true
class Shoes
  module Package
    def self.create_packager(config, wrapper)
      require 'furoshiki/jar'
      require 'furoshiki/jar_app'

      case wrapper
      when 'jar'
        ::Furoshiki::Jar.new(config)
      when 'app'
        ::Furoshiki::JarApp.new(config)
      else
        abort "shoes: Don't know how to make #{config.backend}:#{wrapper} packages"
      end
    end
  end
end
