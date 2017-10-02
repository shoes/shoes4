# frozen_string_literal: true
class Shoes
  CENTER = "center"
  DEFAULT_TEXTBLOCK_FONT = "Arial"

  class TextBlock < Common::UIElement
    include Common::Clickable
    include Common::Hover
    include Common::LinkFinder
    include Common::Translate
    include TextBlockDimensionsDelegations

    attr_reader :text, :contents, :text_styles
    attr_writer :textcursor
    attr_accessor :cursor

    style_with :common_styles, :dimensions, :text_block_styles, :translate
    STYLES = { font: DEFAULT_TEXTBLOCK_FONT }.freeze # used in TextBlock specs only

    def create_dimensions(*_)
      @dimensions = TextBlockDimensions.new @parent, @style
    end

    def add_to_parent(text)
      handle_styles @style

      # Important to use accessor and do this after the backend exists, but
      # before we place ourselves in the parent container!
      self.text = Array(text)

      super
    end

    def in_bounds?(*args)
      @gui.in_bounds?(*args)
    end

    def takes_up_space?
      @style[:align] != "right"
    end

    def remove
      super
      links.each do |link|
        @app.remove_mouse_hover_control(link)
      end
    end

    def text=(*texts)
      replace(*texts[0])
    end

    def replace(*texts)
      opts = texts.pop if texts.last.is_a?(Hash)
      if opts
        style(opts)
        handle_styles(opts)
      end

      # Order here matters as well--backend#replace shouldn't rely on DSL state
      # but the texts that it's passed if it needs information at this point.
      @gui.replace(*texts)

      @text        = texts.map(&:to_s).join
      @contents    = texts
      @text_styles = gather_text_styles(self, texts)
    end

    def to_s
      text
    end

    def contents_alignment(current_position = nil)
      @gui.contents_alignment(current_position)
    end

    def adjust_current_position(current_position)
      @gui.adjust_current_position(current_position)
    end

    def textcursor(line_height = 0)
      @textcursor ||= app.textcursor(line_height)
    end

    def textcursor?
      @textcursor
    end

    def centered?
      style[:align] == CENTER
    end

    def links
      find_links(contents)
    end

    private

    def gather_text_styles(parent_text, texts, styles = {}, start_point = 0)
      texts.each do |text|
        if text.is_a? Shoes::Text
          text.text_block  = self
          text.parent      = parent_text
          end_point        = start_point + text.to_s.length - 1

          # If our endpoint is before our start, it's an empty string. We treat
          # those specially with the (0...0) range that has an empty count.
          range = if end_point < start_point
                    (0...0)
                  else
                    start_point..end_point
                  end

          styles[range] ||= []
          styles[range] << text
          gather_text_styles(text, text.texts, styles, start_point)
        end
        start_point += text.to_s.length
      end
      styles
    end

    def handle_styles(style)
      parse_font_style style[:font] if style[:font] # if is needed for the specs
    end

    def parse_font_style(type)
      size_regex = /(\d+)(\s*px)?/
      style_regex = /none|bold|normal|oblique|italic/i # TODO: add more

      font_family = type.gsub(style_regex, '').gsub(size_regex, '')
                        .split(',').map { |x| x.strip.gsub(/["]/, '') }

      @style[:font] = font_family.first unless (font_family.size == 1 &&
        font_family[0] == "") || font_family.empty?

      fsize = size_regex.match(type)
      @style[:size] = fsize[1].to_i unless fsize.nil?

      # TODO: Style options
    end
  end

  {
    "Banner"      => { size: 48 },
    "Title"       => { size: 34 },
    "Subtitle"    => { size: 26 },
    "Tagline"     => { size: 18 },
    "Caption"     => { size: 14 },
    "Para"        => { size: 12 },
    "Inscription" => { size: 10 }
  }.each do |name, styles|
    clazz = Class.new(TextBlock) do
      const_set("STYLES", { font: DEFAULT_TEXTBLOCK_FONT, fill: nil }.merge(styles))
    end

    Shoes.const_set(name, clazz)

    clazz.class_eval do
      include Shoes::Common::Hover
    end
  end
end
