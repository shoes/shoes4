module Shoes
  class Dialog
    def initialize(parent = nil)
      @gui = Shoes.backend::Dialog.new
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