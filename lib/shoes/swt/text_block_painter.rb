require 'shoes/swt/text_block_fitter'
require 'shoes/swt/text_block_cursor_painter'

class Shoes
  module Swt
    class TextBlockPainter
      include ::Swt::Events::PaintListener
      include Common::Resource
      include Common::Clickable

      attr_reader :app
      def initialize(dsl)
        @dsl = dsl
        @opts = @dsl.opts
        @app = @dsl.app.gui
      end

      def paintControl(paint_event)
        gcs_reset(paint_event.gc)
        return if @dsl.hidden?

        @dsl.gui.fitted_layouts.each do |fitted_layout|
          draw_from_layout(paint_event.gc, fitted_layout)
        end
        draw_text_cursor
      end

      def draw_from_layout(gc, fitted_layout)
        set_styles(fitted_layout)
        fitted_layout.draw(gc)
      end

      def draw_text_cursor
        TextBlockCursorPainter.new(@dsl, @dsl.gui.fitted_layouts).draw
      end

      def set_styles(fitted_layout)
        text_layout = fitted_layout.layout
        text_layout.setJustify @opts[:justify]
        text_layout.setSpacing(@opts[:leading] || 4)
        text_layout.setAlignment case @opts[:align]
                                    when 'center'; ::Swt::SWT::CENTER
                                    when 'right'; ::Swt::SWT::RIGHT
                                    else ::Swt::SWT::LEFT
                                  end
        style = apply_styles(default_text_styles(nil, nil, @opts[:strikecolor], @opts[:undercolor]), @opts)
        set_font_styles(fitted_layout, style, 0..(@dsl.text.length - 1))
        set_text_styles(fitted_layout, style[:fg], style[:bg])
      end

      private

      def apply_styles(styles, opts)
        styles[:font_detail][:styles] = parse_font_style(opts)
        styles[:font_detail][:name] = opts[:font] if opts[:font]
        styles[:fg] = opts[:stroke]
        styles[:bg] = opts[:fill]
        styles[:font_detail][:size] *= opts[:size_modifier] if opts[:size_modifier]
        styles.merge(opts)
      end

      def create_link(fitted_layout, text, range)
        layout = fitted_layout.layout
        start_position = layout.getLocation range.first, false
        end_position = layout.getLocation range.last, true
        left, top =  fitted_layout.left, fitted_layout.top
        text.line_height = layout.getLineBounds(0).height
        text.start_x, text.start_y = left + start_position.x, top + start_position.y
        text.end_x, text.end_y = left + end_position.x, top + end_position.y + text.line_height
        @dsl.links << text
        unless text.clickabled
          text.parent = @dsl
          clickable text, text.blk
          text.clickabled = true
        end
      rescue => e
        # TODO: Once we properly handle links in multi-layout text, this rescue
        # should not be required any longer.
      end

      def set_text_styles(fitted_layout, foreground, background)

        @dsl.text_styles.each do |range, text_styles|
          defaults = default_text_styles(foreground, background, @dsl.opts[:strikecolor], @dsl.opts[:undercolor])
          styles = text_styles.inject(defaults) do |current_styles, text|
            if text.is_a? ::Shoes::Span
              apply_styles(current_styles, text.opts)
            else
              make_link_style(fitted_layout, text, current_styles, range)
            end
          end
          set_font_styles(fitted_layout, styles, range)
        end
      end

      def set_font_styles(fitted_layout, styles, range)
        font_style = styles[:font_detail]
        font = create_font font_style[:name], font_style[:size], font_style[:styles]
        style = create_style font, styles[:fg], styles[:bg], styles
        fitted_layout.layout.setStyle style, range.first, range.last
      end

      def default_text_styles(foreground, background, strikecolor, undercolor)
        {
          :fg          => foreground,
          :bg          => background,
          :strikecolor => strikecolor,
          :undercolor  => undercolor,
          :font_detail => {
            :name   => @dsl.font,
            :size   => @dsl.font_size,
            :styles => [::Swt::SWT::NORMAL]
          }
        }
      end

      def make_link_style(fitted_layout, text, styles, range)
        if text.is_a? ::Shoes::Link
          styles[:underline] = true
          styles[:fg] = ::Swt::Color.new Shoes.display, 0, 0, 255
          create_link(fitted_layout, text, range)
        end
        styles
      end

      def parse_font_style(opts)
        font_styles = []
        font_styles << ::Swt::SWT::BOLD if opts[:weight]
        font_styles << ::Swt::SWT::ITALIC if opts[:emphasis]
        font_styles << ::Swt::SWT::NORMAL if !opts[:weight] && !opts[:emphasis]
        font_styles
      end

      def create_font(name, size, styles)
        #TODO: mark font for garbage collection
        ::Swt::Font.new Shoes.display, name, size, styles.reduce { |result, s| result | s }
      end

      def create_style(font, foreground, background, opts)
        TextStyleFactory.create_style(font, foreground, background, opts)
      end
    end

    module TextStyleFactory
      UNDERLINE_STYLES = {
          "single" => 0,
          "double" => 1,
          "error" => 2,
      }

      def self.create_style(font, foreground, background, opts)
        fg = swt_color(foreground, ::Shoes::COLORS[:black])
        bg = swt_color(background)
        @style = ::Swt::TextStyle.new font, fg, bg
        set_underline(opts)
        set_undercolor(opts)
        set_rise(opts)
        set_strikethrough(opts)
        set_strikecolor(opts)
        @style
      end

      attr_reader :style

      private
      def self.set_rise(opts)
        @style.rise = opts[:rise]
      end

      def self.set_underline(opts)
        @style.underline = opts[:underline].nil? || opts[:underline] == "none" ? false : true
        @style.underlineStyle = UNDERLINE_STYLES[opts[:underline]]
      end

      def self.set_undercolor(opts)
        @style.underlineColor = color_from_dsl opts[:undercolor]
      end

      def self.set_strikethrough(opts)
        @style.strikeout = opts[:strikethrough].nil? || opts[:strikethrough] == "none" ? false : true
      end

      def self.set_strikecolor(opts)
        @style.strikeoutColor = color_from_dsl opts[:strikecolor]
      end

      def self.swt_color(color, default = nil)
        return color if color.is_a? ::Swt::Color
        color_from_dsl color, default
      end

      def self.color_from_dsl(dsl_color, default = nil)
        return nil if dsl_color.nil? and default.nil?
        return color_from_dsl default if dsl_color.nil?
        dsl_color = ::Shoes::Color.create(dsl_color)
        # TODO: mark color for garbage collection
        ::Swt::Color.new(Shoes.display, dsl_color.red, dsl_color.green, dsl_color.blue)
      end
    end
  end
end
