require 'shoes/common_methods'
require 'shoes/common/fill'
require 'shoes/common/stroke'
require 'shoes/common/style'

module Shoes
  class Oval
    include Shoes::CommonMethods
    include Shoes::Common::Fill
    include Shoes::Common::Stroke
    include Shoes::Common::Style

    def initialize(app, left, top, width, height, opts = {})
      @app = app
      @left = left
      @top = top
      @width = width
      @height = height
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)

      # GUI
      @gui = Shoes.backend_for(self, left, top, width, height)
    end

    attr_reader :app
  end
end
