module Shoes
  class Alert
    def initialize(parent, msg = '')
      @parent = parent
      @gui = Shoes.configuration.backend_for(self, @parent.gui, msg)
    end
  end
end