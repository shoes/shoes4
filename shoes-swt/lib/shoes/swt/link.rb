# frozen_string_literal: true

class Shoes
  module Swt
    class Link
      include Common::Clickable
      include Common::Fill
      include Common::Stroke

      attr_reader :app, :link_segments, :dsl

      def initialize(dsl, app)
        @app = app
        @link_segments = []
        @dsl = dsl
      end

      def redraw_target
        @dsl.text_block
      end

      def remove
        @link_segments.clear
        app.click_listener.remove_listeners_for(self)
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
