require 'shoes/common_methods'
require 'shoes/common/fill'
require 'shoes/common/stroke'
require 'shoes/common/style'

module Shoes
  class Curve
    include Shoes::CommonMethods
    include Shoes::Common::Stroke
    include Shoes::Common::Style

    def initialize(app, point_1, control_1, control_2, point_2, opts = {}, &blk)
      @app = app
      @point_1, @control_1, @control_2, @point_2 = point_1, control_1, control_2, point_2

      @style = Shoes::Common::Stroke::DEFAULTS.merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1

      # GUI
      gui_opts = @style.clone
      @app.unslotted_elements << self

      @gui = Shoes.backend_for(self, point_1, control_1, control_2, point_2, gui_opts)
    end

    attr_reader :app, :hidden

    def move(x, y)
      @gui.move x, y
      self
    end
  end
end
