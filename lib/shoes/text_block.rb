class Shoes
  DEFAULT_TEXTBLOCK_FONT = "Arial"

  class TextBlock
    include CommonMethods
    include Common::Clickable
    include DimensionsDelegations

    attr_reader   :gui, :parent, :text, :links, :app, :text_styles, :dimensions, :opts
    attr_accessor :calculated_width, :font, :font_size, :cursor, :textcursor

    def initialize(app, parent, text, font_size, opts = {})
      texts = Array(text)
      @parent             = parent
      @app                = app
      @opts               = opts
      @font               = @app.font || DEFAULT_TEXTBLOCK_FONT
      @font_size          = @opts[:size] || font_size
      @links              = []
      @contents           = texts
      @text               = texts.map(&:to_s).join
      @text_styles        = gather_text_styles(self, texts)

      @opts[:stroke] = Shoes::Color.new(@opts[:stroke]) if @opts[:stroke].is_a?(String)
      @opts[:fill] = Shoes::Color.new(@opts[:fill]) if @opts[:fill].is_a?(String)

      @dimensions   = Dimensions.new parent, opts

      handle_opts @opts

      @opts = @app.style.merge(@opts)

      @gui = Shoes.configuration.backend_for(self)
      @parent.add_child(self)

      clickable_options(@opts)
    end

    def update_text_styles(texts)
      @text_styles = gather_text_styles(self, texts)
    end

    def text=(*values)
      replace *values[0]
    end

    def replace(*values)
      @text = values.map(&:to_s).join
      @gui.replace *values
    end

    def to_s
      self.text
    end

    # Since we flow, try to fit in almost any space
    def fitting_width
      10
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

    def absolute_bottom=(value)
      @absolute_bottom = value
    end

    def absolute_bottom
      return absolute_top + height if @absolute_bottom.nil?
      @absolute_bottom
    end

    def width
      @dimensions.width || self.calculated_width
    end

    # If an explicit width's set, it's used. If not, we look to the parent.
    def containing_width
      @dimensions.width || parent.width
    end

    # This is the width the text block initially wants to try and fit into.
    def desired_width
      parent.absolute_left + containing_width - self.absolute_left
    end

    def contents_alignment(current_position=nil)
      @gui.contents_alignment(current_position)
    end

    def textcursor(line_height = 0)
      @textcursor ||= app.textcursor(line_height)
    end

    def has_textcursor?
      @textcursor
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
      size_regex = /(\d+)(\s*px)?/
      style_regex = /none|bold|normal|oblique|italic/i # TODO: add more

      font_family = type.gsub(style_regex,'').gsub(size_regex,'').
                  split(',').map { |x| x.strip.gsub(/["]/,'') }

      @font = font_family.first unless (font_family.size == 1 and
        font_family[0] == "") or font_family.size == 0

      fsize = size_regex.match(type)
      @font_size = fsize[1].to_i unless fsize.nil?

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
