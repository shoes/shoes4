require 'shoes/common_methods'
require 'shoes/common/fill'
require 'shoes/common/stroke'
require 'shoes/common/style'

module Shoes
  class Curve
    include Shoes::CommonMethods
    include Shoes::Common::Stroke
    include Shoes::Common::Style

    def initialize(app, x1, y1, x2, y2, x3, y3, opts = {}, &blk)
      @app = app
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2
      @x3 = x3
      @y3 = y3

      @style = Shoes::Common::Stroke::DEFAULTS.merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1

      # GUI
      gui_opts = @style.clone
      @app.unslotted_elements << self

      @gui = Shoes.backend_for(self, x1, y1, x2, y2, x3, y3, gui_opts)
    end

    attr_reader :app, :hidden

  end
end
