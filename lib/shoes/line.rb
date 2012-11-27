require 'shoes/common_methods'
require 'shoes/common/fill'
require 'shoes/common/stroke'
require 'shoes/common/style'

module Shoes
  class Line
    include Shoes::CommonMethods
    include Shoes::Common::Stroke
    include Shoes::Common::Style

    def initialize(app, point_a, point_b, opts = {})
      @app = app

      @style = Shoes::Common::Stroke::DEFAULTS.merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1

      # GUI
      gui_opts = @style.clone
      @app.unslotted_elements << self

      @gui = Shoes.backend_for(self, point_a, point_b, gui_opts)
    end

    attr_reader :app, :hidden

    def move(x, y)
      @gui.move x, y
    end

    def left
      @gui.left
    end

    def top
      @gui.top
    end
  end
end
