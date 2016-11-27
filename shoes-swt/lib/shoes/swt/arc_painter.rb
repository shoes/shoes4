class Shoes
  module Swt
    class ArcPainter < Common::Painter
      def fill(graphics_context)
        if @obj.wedge?
          graphics_context.fill_arc(@obj.dsl.translate_left + @obj.element_left,
                                    @obj.dsl.translate_top + @obj.element_top,
                                    @obj.element_width,
                                    @obj.element_height,
                                    @obj.angle1, @obj.angle2 * -1)
        else
          path = ::Swt::Path.new(::Swt.display)
          path.add_arc(@obj.dsl.translate_left + @obj.element_left,
                       @obj.dsl.translate_top + @obj.element_top,
                       @obj.element_width,
                       @obj.element_height,
                       @obj.angle1, @obj.angle2 * -1)
          graphics_context.fill_path(path)
        end
      end

      def draw(graphics_context)
        sw = graphics_context.get_line_width
        if @obj.element_left && @obj.element_top && @obj.element_width && @obj.element_height
          graphics_context.draw_arc(@obj.dsl.translate_left + @obj.element_left + sw / 2,
                                    @obj.dsl.translate_top + @obj.element_top + sw / 2,
                                    @obj.element_width - sw,
                                    @obj.element_height - sw,
                                    @obj.angle1, @obj.angle2 * -1)
        end
      end
    end
  end
end
