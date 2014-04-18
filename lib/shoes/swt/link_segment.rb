class Shoes
  module Swt
    class LinkSegment
      def initialize(layout, range)
        start_position = layout.get_location(range.first, false)
        end_position = layout.get_location(range.last, true)
        left = layout.element_left
        top = layout.element_top

        first_line_height = layout.layout.get_line_bounds(0).height

        @regions = []
        line_count = layout.layout.line_count
        if line_count == 1
          add_region(start_position.x, start_position.y,
                     end_position.x,   end_position.y + first_line_height)
        else line_count >= 2
          add_region(start_position.x,    start_position.y,
                     layout.layout.width, first_line_height)

          last_line_height = layout.layout.get_line_bounds(1).height
          add_region(0,              first_line_height + 1,
                     end_position.x, end_position.y + last_line_height)

          if line_count > 2
            add_region(0,                   start_position.y + first_line_height,
                       layout.layout.width, end_position.y)
          end
        end

        @regions.each {|region| region.offset_by!(left, top)}
      end

      def add_region(left, top, right, bottom)
        @regions << Region.new(left, top, right, bottom)
      end

      def in_bounds?(x, y)
        @regions.any? {|region| region.in_bounds?(x, y)}
      end

      class Region
        def initialize(start_x, start_y, end_x, end_y)
          @start_x = start_x
          @start_y = start_y
          @end_x = end_x
          @end_y = end_y
        end

        def offset_by!(left, top)
          @start_x += left
          @end_x   += left

          @start_y += top
          @end_y   += top
        end

        def in_bounds?(x, y)
          (@start_x..@end_x).include?(x) and (@start_y..@end_y).include?(y)
        end
      end
    end
  end
end
