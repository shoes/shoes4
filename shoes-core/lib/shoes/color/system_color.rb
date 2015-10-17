class Shoes
  class SystemColor < Color

    attr_reader :gui

    def initialize(color_name)
      @gui = Shoes.backend_for(self, color_name)
      @red = gui.red
      @green = gui.green
      @blue = gui.blue
      @alpha = gui.alpha
    end
  end
end
