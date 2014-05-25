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

        attr_reader :layout, :element_left, :element_top

        extend Forwardable
        def_delegators :@layout, :text, :text=, :bounds, :width,
                                 :line_bounds, :line_count, :line_offsets

        def initialize(dsl, text, width)
          @dsl = dsl
          @layout = ::Swt::TextLayout.new Shoes.display
          @font_factory = TextFontFactory.new
          @style_factory = TextStyleFactory.new

          layout.text = text
          style_from(font_styling, @dsl.opts)
          shrink_layout_to(width) unless layout_fits_in?(width)
        end

        def dispose
          @layout.dispose unless @layout.disposed?
          @font_factory.dispose
          @style_factory.dispose
        end

        def position_at(element_left, element_top)
          @element_left = element_left
          @element_top = element_top
          self
        end

        def get_location(cursor, trailing=false)
          @layout.get_location(cursor, trailing)
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

        def font_styling
          {
            font_detail: {
            name: @dsl.font,
            size: @dsl.font_size,
            styles:[::Swt::SWT::NORMAL]
          }
          }
        end

        def shrink_layout_to(width)
          layout.setWidth(width)
        end

        def layout_height
          layout.bounds.height - layout.spacing
        end

        def layout_fits_in?(width)
          layout.bounds.width <= width
        end

        def last_line_height
          layout.line_bounds(layout.line_count - 1).height
        end

        def last_line_width
          layout.line_bounds(layout.line_count - 1).width
        end

        def draw(graphics_context)
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
