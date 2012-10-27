require 'shoes/common_methods'

module Shoes
  DEFAULT_TEXTBLOCK_FONT = "Arial"

  class TextBlock
    include Shoes::CommonMethods

    attr_reader  :gui, :parent, :text
    attr_accessor :font, :font_size, :width, :height, :left, :top

    def initialize(parent, text, font_size, opts = {})
      @parent = parent
      @font = DEFAULT_TEXTBLOCK_FONT
      @font_size = font_size
      @text = text
      @left = opts[:left]
      @top = opts[:top]

      handle_opts opts

      @gui = Shoes.configuration.backend_for(self, opts)
      if text.split.length == 1
        @width, @height = @gui.get_size
        @fixed = true
      end
      @left && @top ? set_size(@left.to_i, @left.to_i) : @parent.add_child(self)
    end

    def app
      @parent.app
    end

    def move left, top
      set_size left, top unless @fixed
      super
    end

    # It might be possible to leave the redraw
    # function blank for non-SWT versions of Shoes
    def text=(value)
      @text = value
      @gui.redraw
    end

    def positioning x, y, max
      set_size @left.to_i, @left.to_i unless @fixed
      super
    end

    def set_size left, top
      @width = (left + @parent.width <= app.width) ? @parent.width : app.width - left
      @height = @gui.get_height
    end

    private

    def handle_opts(opts)
      if opts.has_key? :family
        parse_font_opt opts[:family]
      end
    end

    def parse_font_opt(type)
      size_regex = /\d+(?=px)?/
      style_regex = /none|bold|normal|oblique|italic/i # TODO: add more

      ffamily = type.gsub(style_regex,'').gsub(/\d+(px)?/,'').
                  split(',').map { |x| x.strip.gsub(/["]/,'') }

      @font = ffamily.first unless (ffamily.size == 1 and
        ffamily[0] == "") or ffamily.size == 0

      fsize = type.scan(size_regex)
      @font_size = fsize.first.to_i unless fsize.empty?

      # TODO: Style options
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
