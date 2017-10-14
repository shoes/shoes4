# frozen_string_literal: true

class Shoes
  module Swt
    class ArcPainter < Common::Painter
      FULL_CIRCLE_DEGREES = 360

      def fill(graphics_context)
        if @obj.wedge?
          graphics_context.fill_arc(@obj.translate_left + @obj.element_left,
                                    @obj.translate_top + drawing_top,
                                    @obj.element_width,
                                    @obj.element_height,
                                    start_angle, sweep)
        else
          path = ::Swt::Path.new(::Swt.display)
          path.add_arc(@obj.translate_left + @obj.element_left,
                       @obj.translate_top + drawing_top,
                       @obj.element_width,
                       @obj.element_height,
                       start_angle, sweep)
          graphics_context.fill_path(path)
        end
      end

      def draw(graphics_context)
        line_width = graphics_context.get_line_width
        if @obj.element_left && @obj.element_top && @obj.element_width && @obj.element_height
          graphics_context.draw_arc(@obj.translate_left + @obj.element_left + line_width / 2,
                                    @obj.translate_top + drawing_top + line_width / 2,
                                    @obj.element_width - line_width,
                                    @obj.element_height - line_width,
                                    start_angle, sweep)
        end
      end

      # Shoes angles to run clockwise, with 0 at the 3 o'clock position. SWT
      # instead runs counter-clockwise from 3 o'clock, hence we negate the
      # start angle to translate from Shoes -> SWT
      def start_angle
        -@obj.angle1
      end

      # Shoes represents via a start and end angle, with the fill running
      # clockwise from start to end. If start is greater than end, this just
      # means that we wrap around the 3 o'clock-0 radians point as we run
      # clockwise.
      #
      # SWT instead is start angle plus a sweep, and runs counter-clockwise.
      # Hence we end up calculating a negative (clockwise) sweep. There's a
      # small case difference depending on if we're crossing over the 0 point.
      #
      # See the specs for lots of good examples, with pictures, of this logic.
      #
      def sweep
        if @obj.angle1 <= @obj.angle2
          @obj.angle1 - @obj.angle2
        else
          @obj.angle1 - @obj.angle2 - FULL_CIRCLE_DEGREES
        end
      end
    end
  end
end
