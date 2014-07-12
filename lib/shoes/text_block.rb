class Shoes
  CENTER = "center".freeze
  DEFAULT_TEXTBLOCK_FONT = "Arial"

  class TextBlock
    include CommonMethods
    include Common::Clickable
    include DimensionsDelegations
    include TextBlockDimensionsDelegations

    attr_reader   :gui, :parent, :text, :contents, :app, :text_styles, :dimensions, :opts
    attr_accessor :font, :font_size, :cursor, :textcursor

    def initialize(app, parent, text, font_size, opts = {})
      @parent             = parent
      @app                = app
      @opts               = opts
      @font               = @app.font || DEFAULT_TEXTBLOCK_FONT
      @font_size          = @opts[:size] || font_size

      @opts[:stroke] = Shoes::Color.new(@opts[:stroke]) if @opts[:stroke].is_a?(String)
      @opts[:fill] = Shoes::Color.new(@opts[:fill]) if @opts[:fill].is_a?(String)

      #TODO
      # Workaround until common styling is applied to TextBlock since we get
      # the app-default fill => black styling here otherwise.
      @opts[:fill] = nil unless @opts.include?(:fill)

      @dimensions   = TextBlockDimensions.new parent, opts

      handle_opts @opts

      @opts = @app.style.merge(@opts)

      @gui = Shoes.configuration.backend_for(self)
      @parent.add_child(self)

      # Important to use accessor and do this after the backend exists!
      self.text = Array(text)

      register_click(@opts)
    end

    def in_bounds?(*args)
      @gui.in_bounds?(*args)
    end

    def text=(*texts)
      replace *texts[0]
    end

    def replace(*texts)
      # Order here matters as well--backend#replace shouldn't rely on DSL state
      # but the texts that it's passed if it needs information at this point.
      @gui.replace *texts

      @text        = texts.map(&:to_s).join
      @contents    = texts
      @text_styles = gather_text_styles(self, texts)
    end

    def to_s
      self.text
    end

    def contents_alignment(current_position=nil)
      @gui.contents_alignment(current_position)
    end

    def adjust_current_position(current_position)
      @gui.adjust_current_position(current_position)
    end

    def textcursor(line_height = 0)
      @textcursor ||= app.textcursor(line_height)
    end

    def has_textcursor?
      @textcursor
    end

    def centered?
      opts[:align] == CENTER
    end

    def links
      return [] unless @contents

      @contents.select do |element|
        element.is_a?(Shoes::Link)
      end
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
