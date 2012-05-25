module WhiteShoes
  # Adapter Template for the BaseApp methods specific for the framework.
  module App

    def gui_init
      self.gui_container = "A new Gui Container Instance"
    end

    def gui_open
      # no-op
    end
  end
end

module Shoes
  class App
    include WhiteShoes::App
  end
end

