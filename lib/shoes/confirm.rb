module Shoes
  class Confirm
    def initialize(parent, msg = '')
      @parent = parent
      @gui = Shoes.configuration.backend_for(self, @parent.gui, msg)
    end
  end
end