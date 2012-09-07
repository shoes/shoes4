require 'facets/kernel/constant'
require 'facets/string'

module Shoes
  class Configuration
    class << self
      def reset
        @logger = nil
        @logger_instance = nil
      end

      def backend
        @backend
      end

      # The Shoes backend to use. Can only be set once.
      #
      # @param [Symbol] backend The backend's name
      # @return [Module] The backend's root module
      # @example
      #   Shoes::Configuration.backend = :swt # => Shoes::Swt
      def backend=(backend)
        require "shoes/#{backend.to_s.downcase}"
        @backend ||= Shoes.const_get(backend.to_s.capitalize)
      rescue LoadError => e
        raise LoadError, "Couldn't load backend '#{backend}'. Error: #{e.message}\n#{e.backtrace.join("\n")}"
      end

      # Finds the appropriate backend class for the given Shoes object
      #
      # @param [Object] shoes_object A Shoes object
      # @return [Object] An appropriate backend class
      # @example
      #   Shoes.configuration.backend_class(shoes_button) # => Shoes::Swt::Button
      def backend_class(shoes_object)
        class_name = shoes_object.class.name.split("::").last
        self.backend.const_get(class_name)
      end

      # Creates an appropriate backend object
      #
      # @param [Object] shoes_object A Shoes object
      # @param *args The arguments for the backend object
      # @return [Object] An appropriate backend object
      # @example
      #   Shoes.configuration.backend_for(button, args) # => <Shoes::Swt::Button:0x12345678>
      def backend_for(shoes_object, *args)
        backend_class(shoes_object).new(shoes_object, *args)
      end

      # Experimental replacement for #backend_for
      def backend_with_app_for(shoes_object, *args, &blk)
        backend_class(shoes_object).new(shoes_object, shoes_object.app.gui, *args, &blk)
      end

      def logger=(value)
        @logger = value
        @logger_instance = nil
      end

      def logger
        @logger ||= :ruby
      end

      def logger_instance
        @logger_instance ||= Shoes::Logger.get(self.logger).new
      end
    end
  end
end

def Shoes.configuration
  Shoes::Configuration
end

def Shoes.backend_for(shoes_object, *args, &blk)
  Shoes::Configuration.backend_with_app_for(shoes_object, *args, &blk)
end
