class Shoes
  module Swt
    class Link
      include Common::Clickable

      attr_reader :app, :link_segments, :dsl

      def initialize(dsl, app)
        @app = app
        @link_segments = []
        @dsl = dsl
      end

      def remove
        @link_segments.clear
        remove_listener_for self, ::Swt::SWT::MouseDown
      end

      def create_links_in(text_segment_ranges)
        @link_segments.clear
        text_segment_ranges.each do |text_segment, range|
          @link_segments << LinkSegment.new(text_segment, range)
        end
      end

      def in_bounds?(x, y)
        @link_segments.any? { |segment| segment.in_bounds?(x, y) }
      end
    end
  end
end
