module Shoes
  class Arc
    include CommonMethods

    def initialize(left, top, width, height, angle1, angle2, opts = {})
      @left, @top, @width, @height = left, top, width, height
      #@angle1, @angle2 = angle1, angle2
      #@style = opts

      #GUI
      gui_opts = {:width => @width, :height => @height}
      @gui = Shoes.configuration.backend_for(self, gui_opts)
    end
  end
end
