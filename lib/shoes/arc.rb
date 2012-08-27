module Shoes
  class Arc
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style

    def initialize(app, left, top, width, height, angle1, angle2, opts = {})
      @app = app
      @left, @top = left, top
      @angle1, @angle2 = angle1, angle2
      @wedge = opts[:wedge] || false
      default_style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS)
      @style = default_style.merge(opts)

      #GUI
      gui_opts = {:left => left, :top => top, :width => width, :height => height}
      @gui = Shoes.backend_for(self, gui_opts)
    end

    attr_reader :app
    attr_reader :angle1, :angle2

    # @return [Boolean] if fill should be a wedge shape, rather than a chord
    #   Defaults to false
    def wedge?
      true unless @wedge == false
    end
  end
end
