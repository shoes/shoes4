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

    def ask msg, args
      @gui.ask msg, args
    end

    def ask_color title
      @gui.ask_color title
    end
  end
end