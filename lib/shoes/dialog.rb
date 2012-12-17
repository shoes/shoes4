module Shoes
  class Dialog
    def initialize
      @gui = Shoes.backend::Dialog.new
    end

    def alert(msg = '')
      @gui.alert msg
    end

    def confirm(msg = '')
      @gui.confirm msg
    end
  end
end