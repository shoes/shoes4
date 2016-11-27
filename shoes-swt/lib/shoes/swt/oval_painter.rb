class Shoes
  module Swt
    class OvalPainter < Common::Painter
      def clipping
        clipping = ::Swt::Path.new(Shoes.display)
        clipping.add_arc(@obj.element_left, @obj.element_top,
                         @obj.element_width, @obj.element_height, 0, 360)
        clipping
      end

      def fill(graphics_context)
        graphics_context.fill_oval(@obj.dsl.translate_left + @obj.element_left,
                                   @obj.dsl.translate_top + @obj.element_top,
                                   @obj.element_width,
                                   @obj.element_height)
      end

      def draw(graphics_context)
        sw = graphics_context.get_line_width
        graphics_context.draw_oval(@obj.dsl.translate_left + @obj.element_left + sw / 2,
                                   @obj.dsl.translate_top + @obj.element_top + sw / 2,
                                   @obj.element_width - sw,
                                   @obj.element_height - sw)
      end
    end
  end
end
