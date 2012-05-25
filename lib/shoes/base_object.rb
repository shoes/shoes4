require 'facets/kernel/constant'
require 'facets/string'

module Shoes
  class BaseObject

    def framework
      
      begin
        self_klass = self.class.to_s.split("::")[-1]
        framework_klass = Shoes.configuration.framework.camelcase + "::#{self_klass}"
        constant(framework_klass)
      rescue NameError
        unless @tried
          require Shoes.configuration.framework
          @tried = true
          retry
        end
      end

    end
  end
end
