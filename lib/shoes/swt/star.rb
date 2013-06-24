module Shoes
  module Swt
    class Star
      include Common::Fill
      include Common::Stroke
      include Common::Move
      include Common::Clickable
      include Common::Toggle
      include Common::Clear

      def initialize(dsl, app, left, top, points, outer, inner, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @container = @app.real
        @left = left
        @top = top
        @width = @height = outer*2.0
        @points = points
        @outer = outer
        @inner = inner
        @angle = opts[:angle] || 0

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
        clickable blk if blk
      end

      attr_reader :dsl, :angle
      attr_reader :transform
      attr_reader :painter
      attr_accessor :width, :height, :left, :top, :points, :outer, :inner

      class Painter < Common::Painter
        def fill(gc)
          gc.fillPolygon make_polygon(@obj)
        end

        def draw(gc)
          gc.drawPolygon make_polygon(@obj)
        end
        
        def make_polygon obj
          outer, inner, points, left, top = obj.outer, obj.inner, obj.points, obj.left, obj.top
          polygon = []
          polygon << left << (top + outer)
          (1..points*2).each do |i|
            angle =  i * ::Math::PI / points
            r = (i % 2 == 0) ? outer : inner
            polygon << (left + r * ::Math.sin(angle)) << (top + r * ::Math.cos(angle))
          end
          polygon
        end
      end
    end
  end
end
