class Shoes
  module Swt
    class StarPainter < Common::Painter
      def fill(gc)
        gc.fillPolygon make_polygon(@obj)
      end

      def draw(gc)
        gc.drawPolygon make_polygon(@obj)
      end

      def make_polygon(obj)
        outer = obj.outer
        inner = obj.inner
        points = obj.points
        left = obj.translate_left + obj.element_left
        top = obj.translate_top + obj.element_top
        @polygon = []
        add_edge(left, top + outer)
        (1..points * 2).each do |i|
          make_edge(i, left, top, outer, inner, points)
        end

        translate_to_proper_start(obj)

        @polygon
      end

      def add_edge(start, finish)
        @polygon << start << finish
      end

      def make_edge(i, left, top, outer, inner, points)
        r = i.even? ? outer : inner
        angle = i * ::Math::PI / points
        add_edge(left + r * ::Math.sin(angle),
                 top  + r * ::Math.cos(angle))
      end

      # Prior logic centers start on left/top, so translate to where we
      # really want to start.
      def translate_to_proper_start(obj)
        return if obj.dsl.style[:center]

        @polygon.map! do |x|
          x + obj.element_width / 2
        end
      end
    end
  end
end
