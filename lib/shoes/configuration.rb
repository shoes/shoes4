require 'facets/kernel/constant'
require 'facets/string'

module Shoes
  class Configuration
    class << self
      def reset
        @logger = nil
        @logger_instance = nil
      end

      attr_reader :framework
      def framework=(value)
        @framework = value
        require value
      end
      def framework_class
        constant(@framework.camelcase)
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
