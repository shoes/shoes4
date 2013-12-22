class Shoes
  DEFAULT_TEXTBLOCK_FONT = "Arial"

  class TextBlock
    include CommonMethods
    include Common::Clickable
    include DimensionsDelegations


    attr_reader   :gui, :parent, :text, :links, :app, :text_styles, :dimensions, :opts
    attr_accessor :font, :font_size, :cursor, :textcursor

    def initialize(app, parent, text, font_size, opts = {})
      @parent             = parent
      @app                = app
      @opts               = opts
      @font               = @app.font || DEFAULT_TEXTBLOCK_FONT
      @font_size          = @opts[:size] || font_size
      @links              = []
      @contents           = text
      @text               = text.map(&:to_s).join
      @text_styles        = gather_text_styles(self, text)

      @opts[:stroke] = Shoes::Color.new(@opts[:stroke]) if @opts[:stroke].is_a?(String)
      @opts[:fill] = Shoes::Color.new(@opts[:fill]) if @opts[:fill].is_a?(String)

      @dimensions   = Dimensions.new parent, opts

      handle_opts @opts

      @opts = @app.style.merge(@opts)

      @gui = Shoes.configuration.backend_for(self)
      self.width, self.height = @gui.get_size
      @parent.add_child(self)
      set_size left

      clickable_options(@opts)
    end

    def update_text_styles(texts)
      @text_styles = gather_text_styles(self, texts)
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

    def set_size left
      self.width = (left + @parent.width <= app.width) ? @parent.width : app.width - left
      self.height = @gui.get_height + margin_top + margin_bottom
    end

    # We always claim we fit, and do our own wrapping if we don't
    def fits_in_width?(_)
      true
    end

    # We take over a bunch of the absolute_* measurements since the jagged
    # shape of a flowed TextBlock doesn't follow the usual rules for dimensions
    # when we get to positioning (which is the main use of these values).
    def absolute_right=(value)
      @absolute_right = value
    end

    def absolute_right
      return @dimensions.absolute_right if @absolute_right.nil?
      @absolute_right
    end

    def absolute_top=(value)
      @absolute_top = value
    end

    def absolute_top
      return @dimensions.absolute_top if @absolute_top.nil?
      @absolute_top
    end

    def absolute_bottom
      absolute_top + height
    end

    def contents_alignment(current_position=nil)
      @gui.contents_alignment(current_position)
    end

    private

    def gather_text_styles(parent, texts, styles={}, start_point=0)
      texts.each do |text|
        if text.is_a? Shoes::Text
          text.parent = parent
          end_point = start_point + text.to_s.length - 1
          range = start_point..end_point
          styles[range] ||= []
          styles[range] << text
          gather_text_styles(text, text.texts, styles, start_point)
        end
        start_point += text.to_s.length
      end
      styles
    end

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
