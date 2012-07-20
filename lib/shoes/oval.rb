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

    def initialize(*opts)
      defaults = {:left => 0, :top => 0, :width => 0, :height => 0, :radius => 0, :center => false}
      @style = opts.last.class == Hash ? opts.pop : {}
      case opts.length
        when 0, 1
        when 2; @style[:left], @style[:top] = opts
        when 3; @style[:left], @style[:top], @style[:radius] = opts
        else @style[:left], @style[:top], @style[:width], @style[:height] = opts
      end
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(defaults).merge(@style)
      @left = @style[:left]
      @top = @style[:top]
      @width = @style[:width]
      @height = @style[:height]
      @width = @style[:radius] * 2 if @width.zero?
      @height = @width if @height.zero?
      if @style[:center]
        @left -= @width / 2 if @width > 0
        @top -= @height / 2 if @height > 0
      end

      # GUI
      @style.delete(:gui)
      @gui = Shoes.configuration.backend_for(self, @style)
    end
  end
end
