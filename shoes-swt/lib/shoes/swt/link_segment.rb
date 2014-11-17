class Shoes
  module Swt
    class LinkSegment
      def initialize(text_segment, range)
        @regions = []
        @range = range
        @text_segment = text_segment

        # Don't create regions for empty links!
        return unless @range.count > 0

        add_regions_for_lines(lines_for_link)
        offset_regions(text_segment.element_left, text_segment.element_top)
      end

      def add_regions_for_lines(lines)
        first_line = lines.shift
        last_line  = lines.pop

        if last_line.nil?
          add_region_for_single_line(first_line)
        else
          add_regions_for_first_and_last_lines(first_line, last_line)
          add_regions_for_remaining_lines(lines)
        end
      end

      def lines_for_link
        line_bounds.select do |bound|
          line_in_bounds?(bound)
        end
      end

      def line_bounds
        (0..layout.line_count - 1).map do |index|
          layout.line_bounds(index)
        end
      end

      def line_in_bounds?(bound)
        bound.y >= start_position.y && bound.y <= end_position.y
      end

      def add_region_for_single_line(first_line)
        add_region(start_position.x, start_position.y,
                   end_position.x,   end_position.y + first_line.height)
      end

      def add_regions_for_first_and_last_lines(first_line, last_line)
        add_region(start_position.x, start_position.y,
                   layout.width,     start_position.y + first_line.height)
        add_region(0,              end_position.y,
                   end_position.x, end_position.y + last_line.height)
      end

      def add_regions_for_remaining_lines(lines)
        lines.each do |line|
          add_region(line.x,              line.y,
                     line.x + line.width, line.y + line.height)
        end
      end

      def add_region(left, top, right, bottom)
        @regions << Region.new(left, top, right, bottom)
      end

      def offset_regions(left, top)
        @regions.each do |region|
          region.offset_by!(left, top)
        end
      end

      def in_bounds?(x, y)
        @regions.any? { |region| region.in_bounds?(x, y) }
      end

      def start_position
        @text_segment.get_location(@range.first, false)
      end

      def end_position
        @text_segment.get_location(@range.last, true)
      end

      def layout
        @text_segment.layout
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
          (@start_x..@end_x).include?(x) && (@start_y..@end_y).include?(y)
        end
      end
    end
  end
end
