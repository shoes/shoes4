require 'delegate'

class Shoes
  class Packager < SimpleDelegator
    def initialize
      packager = Shoes.configuration.backend_for(self)
      super(packager)
    end
  end
end
