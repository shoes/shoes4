class Shoes
  module Swt
    class Link
      include Common::Clickable

      attr_reader :app, :link_segments

      def initialize(dsl, app, opts={})
        @app = app
        @link_segments = []
        clickable self, dsl.blk
      end

      def create_links_in(layout_ranges)
        @link_segments.clear
        layout_ranges.each do |layout, range|
          @link_segments << LinkSegment.new(layout, range)
        end
      end

      def in_bounds?(x, y)
        @link_segments.any? {|segment| segment.in_bounds(x, y)}
      end
    end

    class LinkSegment
      def initialize(layout, range)
        start_position = layout.get_location(range.first, false)
        end_position = layout.get_location(range.last, true)
        left = layout.element_left
        top = layout.element_top

        # TODO: Wrong assuming height based off first line, but there you go.
        line_height = layout.layout.get_line_bounds(0).height

        @start_x = left + start_position.x
        @start_y = top + start_position.y
        @end_x = left + end_position.x
        @end_y = top + end_position.y + line_height
      end

      def in_bounds(x, y)
        (@start_x..@end_x).include?(x) and (@start_y..@end_y).include?(y)
      end
    end
  end
end
