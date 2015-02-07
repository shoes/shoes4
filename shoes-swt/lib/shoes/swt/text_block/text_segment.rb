class Shoes
  module Swt
    class TextBlock
      # Resources created here need to be disposed (see #dispose). Note that
      # this applies to ::Swt::Font and ::Swt::TextLayout. ::Swt::TextStyle
      # does not need to be disposed, because it is not backed by system
      # resources.
      #
      # The instance factories and our own instances will track these resources
      # and ensure that they get properly disposed when TextBlock or Fitter
      # tell us we're done.
      #
      # These are only expected to be called during contents_alignment
      class TextSegment
        DEFAULT_SPACING = 4

        attr_reader   :layout, :element_left, :element_top
        attr_accessor :fill_background

        extend Forwardable
        def_delegators :@layout, :text, :text=, :bounds, :width, :spacing,
                       :line_bounds, :line_count, :line_offsets

        def initialize(dsl, text, width)
          @dsl = dsl
          @layout = ::Swt::TextLayout.new Shoes.display
          @fill_background = false

          @font_factory = TextFontFactory.new
          @style_factory = TextStyleFactory.new
          @color_factory = ColorFactory.new

          layout.text = text
          layout.width = width
          style_from(font_styling, @dsl.style)
        end

        def dispose
          @layout.dispose unless @layout.disposed?
          @font_factory.dispose
          @style_factory.dispose
          @color_factory.dispose
        end

        def position_at(element_left, element_top)
          @element_left = element_left
          @element_top = element_top
          self
        end

        def get_location(cursor, trailing = false)
          @layout.get_location(cursor, trailing)
        end

        def style_from(default_text_styles, style)
          layout.justify = style[:justify]
          layout.spacing = (style[:leading] || DEFAULT_SPACING)
          layout.alignment = case style[:align]
                             when 'center' then ::Swt::SWT::CENTER
                             when 'right' then  ::Swt::SWT::RIGHT
                             else           ::Swt::SWT::LEFT
                             end

          set_style(TextStyleFactory.apply_styles(default_text_styles, style))
        end

        def set_style(styles, range = (0...text.length))
          # If we've been given an empty/nonsense range, just ignore it
          return unless range.count > 0

          font = @font_factory.create_font(styles[:font_detail])
          style = @style_factory.create_style(font, styles[:fg], styles[:bg], styles)
          layout.set_style(style, range.min, range.max)
        end

        def font_styling
          {
            font_detail: {
              name: @dsl.font,
              size: @dsl.size,
              styles: [::Swt::SWT::NORMAL]
            }
          }
        end

        def height
          layout.bounds.height - layout.spacing
        end

        def last_line_height
          layout.line_bounds(layout.line_count - 1).height
        end

        def last_line_width
          layout.line_bounds(layout.line_count - 1).width
        end

        def draw(graphics_context)
          # Why not use TextLayout's background? Unfortunately it doesn't draw
          # all the way to the edges--just around the literal text. This leaves
          # things jagged when we flow, so do it ourselves.
          if fill_background && @dsl.style[:fill]
            background_color = @color_factory.create(@dsl.style[:fill])
            background_color.apply_as_fill(graphics_context)
            graphics_context.fill_rectangle(element_left, element_top, width, height)
          end

          layout.draw(graphics_context, element_left, element_top)
        end

        # x,y in app coordinates, so translate for layout's element-local values
        def in_bounds?(x, y)
          layout.bounds.contains?(x - element_left, y - element_top)
        end
      end
    end
  end
end
