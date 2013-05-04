require 'shoes/common_methods'
require 'shoes/common/fill'
require 'shoes/common/stroke'
require 'shoes/common/style'

module Shoes
  class Border
    include CommonMethods
    include Common::Style
    include Common::Fill
    include Common::Stroke

    def initialize(app, parent, color, opts = {}, blk = nil)
      @app = app
      @parent = parent

      @left = opts[:left] || 0
      @top = opts[:top] || 0
      @width = opts[:width] || 0
      @height = opts[:height] || 0
      @corners = opts[:curve] || 0
      opts[:stroke] = color

      @style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1

      @gui = Shoes.backend_for(self, left, top, width, height, opts, &blk)
    end

    attr_reader :app, :hidden
    attr_reader :gui, :parent
    attr_reader :corners
    attr_accessor :width, :height
  end
end
