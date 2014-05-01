class Shoes
  module Swt
    class FittedTextLayout
      DEFAULT_SPACING = 4

      attr_reader :layout, :element_left, :element_top

      def initialize(layout, element_left, element_top)
        @layout = layout
        @element_left = element_left
        @element_top = element_top
        @font_factory = TextFontFactory.new
        @style_factory = TextStyleFactory.new
      end

      def get_location(cursor, trailing=false)
        @layout.get_location(cursor, trailing)
      end

      def text
        @layout.text
      end

      def style_from(default_text_styles, opts)
        layout.justify = opts[:justify]
        layout.spacing = (opts[:leading] || DEFAULT_SPACING)
        layout.alignment = case opts[:align]
                             when 'center'; ::Swt::SWT::CENTER
                             when 'right';  ::Swt::SWT::RIGHT
                             else           ::Swt::SWT::LEFT
                           end

        set_style(TextStyleFactory.apply_styles(default_text_styles, opts))
      end

      def set_style(styles, range=(0...text.length))
        font = @font_factory.create_font(styles[:font_detail])
        style = @style_factory.create_style(font, styles[:fg], styles[:bg], styles)
        layout.set_style(style, range.min, range.max)
      end

      def draw(graphics_context)
        layout.draw(graphics_context, element_left, element_top)
      end

      # x,y in app coordinates, so translate for layout's element-local values
      def in_bounds?(x, y)
        layout.bounds.contains?(x - element_left, y - element_top)
      end

      def dispose
        @font_factory.dispose
        @style_factory.dispose
      end
    end
  end
end
