require 'shoes/common_methods'
require 'shoes/common/margin'

module Shoes
  DEFAULT_TEXTBLOCK_FONT = "Arial"

  class TextBlock
    include Shoes::CommonMethods
    include Shoes::Common::Margin

    attr_reader  :gui, :parent, :text, :links, :app, :hidden
    attr_accessor :font, :font_size, :width, :height, :left, :top, :fixed, :cursor, :textcursor

    def initialize(app, parent, text, font_size, opts = {})
      @parent = parent
      @app = app
      @font = @app.font || DEFAULT_TEXTBLOCK_FONT
      @font_size = opts[:size] || font_size
      @text = text
      @left = opts[:left]
      @top = opts[:top]
      @links = []
      opts[:stroke] = Shoes::Color.new(opts[:stroke]) if opts[:stroke].is_a?(String)
      opts[:fill] = Shoes::Color.new(opts[:fill]) if opts[:fill].is_a?(String)

      @margin = opts[:margin]
      set_margin

      handle_opts opts

      @gui = Shoes.configuration.backend_for(self, opts)
      if text.split.length == 1
        @width, @height = @gui.get_size
        @fixed = true
      end
      @left && @top ? set_size(@left.to_i, @left.to_i) : @parent.add_child(self)
    end

    def move left, top
      set_size left, top unless @fixed
      super
    end

    def text=(*values)
      @gui.replace *values[0]
    end

    def replace *values
      @gui.replace *values
    end

    def to_s
      self.text
    end

    def positioning x, y, max
      set_size @left.to_i, @top.to_i
      super
    end

    def set_size left, top
      unless @fixed
        @width = (left + @parent.width <= app.width) ? @parent.width : app.width - left
      end
      @height = @gui.get_height + @margin_top + @margin_bottom
    end

    private

    def handle_opts(opts)
      if opts.has_key? :font
        parse_font_opt opts[:font]
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
