class Shoes
  DEFAULT_TEXTBLOCK_FONT = "Arial"

  class TextBlock
    include CommonMethods
    include Common::Margin
    include Common::Clickable
    include DimensionsDelegations


    attr_reader  :gui, :parent, :text, :links, :app, :text_styles, :dimensions
    attr_accessor :font, :font_size, :fixed,
                  :cursor, :textcursor

    def initialize(app, parent, text, font_size, opts = {})
      @parent       = parent
      @app          = app
      @font         = @app.font || DEFAULT_TEXTBLOCK_FONT
      @font_size    = opts[:size] || font_size
      @text         = text
      @links        = []
      @text_styles  = opts[:text_styles]
      opts[:stroke] = Shoes::Color.new(opts[:stroke]) if opts[:stroke].is_a?(String)
      opts[:fill]   = Shoes::Color.new(opts[:fill]) if opts[:fill].is_a?(String)
      @dimensions   = Dimensions.new opts
      @margin       = opts[:margin]
      set_margin

      handle_opts opts

      @gui = Shoes.configuration.backend_for(self, opts)
      if text.split.length == 1
        self.width, self.height = @gui.get_size
        @fixed = true
      end
      (left != 0) && (top != 0) ? set_size(@left.to_i, @left.to_i) : @parent.add_child(self)
      set_size left, top unless @fixed


      clickable_options(opts)
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

    def set_size left, top
      unless @fixed
        self.width = (left + @parent.width <= app.width) ? @parent.width : app.width - left
      end
      self.height = @gui.get_height + @margin_top + @margin_bottom
    end

    private

    def handle_opts(opts)
      parse_font_opt opts[:font] if opts.has_key? :font
    end

    def parse_font_opt(type)
      size_regex = /\d+(?=px)?/
      style_regex = /none|bold|normal|oblique|italic/i # TODO: add more

      font_family = type.gsub(style_regex,'').gsub(/\d+(px)?/,'').
                  split(',').map { |x| x.strip.gsub(/["]/,'') }

      @font = font_family.first unless (font_family.size == 1 and
        font_family[0] == "") or font_family.size == 0

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
