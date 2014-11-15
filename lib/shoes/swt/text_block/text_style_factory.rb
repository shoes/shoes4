class Shoes
  module Swt
    class TextStyleFactory
      UNDERLINE_STYLES = {
        "single" => 0,
        "double" => 1,
        "error" => 2,
      }

      def initialize
        @colors = []
      end

      def dispose
        @colors.each { |color| color.dispose unless color.disposed? }
        @colors.clear
      end

      def create_style(font, foreground, background, style)
        fg = swt_color(foreground, ::Shoes::COLORS[:black])
        bg = swt_color(background)
        @gui_style = ::Swt::TextStyle.new font, fg, bg
        set_underline(style)
        set_undercolor(style)
        set_rise(style)
        set_strikethrough(style)
        set_strikecolor(style)
        @gui_style
      end

      def self.apply_styles(gui_style, dsl_style)
        gui_style[:font_detail][:styles] = parse_font_style(dsl_style)
        gui_style[:font_detail][:name] = dsl_style[:font] if dsl_style[:font]
        gui_style[:font_detail][:size] = dsl_style[:size] if dsl_style[:size]
        gui_style[:fg] = dsl_style[:stroke]
        gui_style[:bg] = dsl_style[:fill]
        gui_style[:font_detail][:size] *= dsl_style[:size_modifier] if dsl_style[:size_modifier]
        gui_style.merge(dsl_style)
      end

      def self.parse_font_style(style)
        font_styles = []
        font_styles << ::Swt::SWT::BOLD if style[:weight]
        font_styles << ::Swt::SWT::ITALIC if style[:emphasis]
        font_styles << ::Swt::SWT::NORMAL if !style[:weight] && !style[:emphasis]
        font_styles
      end

      private

      def set_rise(style)
        @gui_style.rise = style[:rise]
      end

      def set_underline(style)
        @gui_style.underline = style_present? style[:underline]
        @gui_style.underlineStyle = UNDERLINE_STYLES[style[:underline]]
      end

      def set_undercolor(style)
        @gui_style.underlineColor = color_from_dsl style[:undercolor]
      end

      def set_strikethrough(style)
        @gui_style.strikeout = style_present? style[:strikethrough]
      end

      def set_strikecolor(style)
        @gui_style.strikeoutColor = color_from_dsl style[:strikecolor]
      end

      def swt_color(color, default = nil)
        return color if color.is_a? ::Swt::Color
        color_from_dsl color, default
      end

      def color_from_dsl(dsl_color, default = nil)
        return nil if dsl_color.nil? && default.nil?
        return color_from_dsl default if dsl_color.nil?
        color = ::Swt::Color.new(Shoes.display, dsl_color.red, dsl_color.green, dsl_color.blue)

        # Hold a reference to the color so we can dispose it when the time comes
        @colors << color

        color
      end

      private
      def style_present?(style)
        !style.nil? && !(style == 'none')
      end
    end
  end
end
