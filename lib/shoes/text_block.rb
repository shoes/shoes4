require 'shoes/common_methods'

module Shoes
  class TextBlock
    include Shoes::CommonMethods

    attr_reader  :gui, :parent, :text
    attr_accessor :font, :font_size, :width, :height, :left, :top

    def initialize(parent, text, font_size, opts = {})
      @parent = parent
      @font = 'sans'
      @font_size = font_size
      @text = text

      @gui = Shoes.configuration.backend_for(self, opts)
      if text.split.length == 1
        @width, @height = @gui.get_size
        @fixed = true
      end
      @parent.add_child self
    end

    def app
      @parent.app
    end


    # It might be possible to leave the redraw
    # function blank for non-SWT versions of Shoes
    def text=(value)
      @text = value
      @gui.redraw
    end

    def positioning x, y, max
      unless @fixed
        @width = (@left.to_i + @parent.width <= app.width) ? @parent.width : app.width - @left.to_i
        @height = @gui.get_height
      end
      super
    end
  end

  class Banner < TextBlock; end
  class Title < TextBlock; end
  class Subtitle < TextBlock; end
  class Tagline < TextBlock; end
  class Caption < TextBlock; end
  class Para < TextBlock; end
  class Inscription < TextBlock; end
end
