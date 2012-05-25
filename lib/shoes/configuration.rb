require 'facets/kernel/constant'
require 'facets/string'

module Shoes
  class Configuration
    class << self
      attr_accessor :framework

      def framework=(value)
        @framework = value
        require value
      end
      def framework_class
        constant(@framework.camelcase)
      end
    end

  end
end

def Shoes.configuration
  Shoes::Configuration
end
