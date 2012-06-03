require 'facets/kernel/constant'
require 'facets/string'

module Shoes
  class Configuration
    class << self
      def reset
        @logger = nil
        @logger_instance = nil
      end

      # @return [String] The require string for the framework class
      # @todo Should be the class itself
      attr_reader :framework

      # Set the backend framework
      #
      # @param [String] value The require for the backend
      # @return [String] The require for the backend
      # @example
      #   Shoes.configuration.framework = 'shoes/swt'
      # @todo This should receive :swt, :swing, etc. instead of
      #   'shoes/swt', 'shoes/swing', etc.
      # @todo Merge into #backend
      def framework=(value)
        @framework = value
        require value
        @framework
      end

      def framework_class
        constant(@framework.camelcase)
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
      #   Shoes.backend = :swt # => Shoes::Swt
      def backend=(backend)
        require "shoes/#{backend.to_s.downcase}"
        @backend ||= Shoes.const_get(backend.to_s.capitalize)
      rescue LoadError
        raise ArgumentError, "Unknown backend: #{backend}"
      end

      def backend_class(shoes_object)
        class_name = shoes_object.class.name.split("::").last
        self.backend.const_get(class_name)
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
