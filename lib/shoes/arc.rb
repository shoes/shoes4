module Shoes
  class Arc
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style

    def initialize(left, top, width, height, angle1, angle2, opts = {})
      @left, @top, @width, @height = left, top, width, height
      #@angle1, @angle2 = angle1, angle2
      default_style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS)
      @style = default_style.merge(opts)

      #GUI
      gui_opts = {:width => @width, :height => @height}
      @gui = Shoes.configuration.backend_for(self, gui_opts)
    end
  end
end
