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
    
    def dialog_chooser title, folder=false
      @gui.dialog_chooser title, folder
    end

    def ask msg
      @gui.ask msg
    end
  end
end