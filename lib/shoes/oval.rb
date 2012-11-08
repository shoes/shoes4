require 'shoes/common_methods'
require 'shoes/common/fill'
require 'shoes/common/stroke'
require 'shoes/common/style'
require 'shoes/common/clickable'

module Shoes
  class Oval
    include Shoes::CommonMethods
    include Shoes::Common::Fill
    include Shoes::Common::Stroke
    include Shoes::Common::Style
    include Shoes::Common::Clickable

    def initialize(app, left, top, width, height, opts = {}, &blk)
      @app = app
      @left = left
      @top = top
      @width = width
      @height = height
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)
      @app.unslotted_elements << self

      # GUI
      @gui = Shoes.backend_for(self, left, top, width, height, &blk)
    end

    attr_reader :app, :hidden
  end
end
