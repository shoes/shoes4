module Shoes
  class Arc
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style

    def initialize(left, top, width, height, angle1, angle2, opts = {})
      @left, @top = left, top
      @angle1, @angle2 = angle1, angle2
      default_style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS)
      @style = default_style.merge(opts)

      #GUI
      gui_opts = {:left => left, :top => top, :width => width, :height => height, :app => opts[:app].gui}
      @gui = Shoes.configuration.backend_for(self, gui_opts)
    end

    attr_reader :angle1, :angle2
  end
end
