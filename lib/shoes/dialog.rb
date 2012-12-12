module Shoes
  class Dialog
    def initialize(parent = nil)
      @parent = parent
      @gui = Shoes.configuration.backend_for(self, @parent.gui)
    end

    def alert(msg = '')
      @gui.alert msg
    end

    def confirm(msg = '')
      @gui.confirm msg
    end

    alias_method :confirm?, :confirm
  end
end