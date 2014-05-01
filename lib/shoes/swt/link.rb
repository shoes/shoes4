class Shoes
  module Swt
    class Link
      include Common::Clickable

      attr_reader :app, :link_segments, :dsl

      def initialize(dsl, app, opts={})
        @app = app
        @link_segments = []
        @dsl = dsl

        # Important to capture a block that executes the DSL's current block,
        # not just the block the DSL had when initializing, since a `click`
        # call can change the block but won't update the clickable listener.
        # See issue #639 for how we'd like to fix this in clickable.
        clickable self, Proc.new { dsl.execute_link }
      end

      def clear
        @link_segments.clear
        remove_listener_for(self)
      end

      def create_links_in(layout_ranges)
        @link_segments.clear
        layout_ranges.each do |layout, range|
          @link_segments << LinkSegment.new(layout, range)
        end
      end

      def in_bounds?(x, y)
        @link_segments.any? {|segment| segment.in_bounds?(x, y)}
      end
    end
  end
end
