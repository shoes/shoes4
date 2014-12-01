class Shoes
  module Swt
    class Star
      extend Forwardable
      include Common::Fill
      include Common::Stroke
      include Common::Clickable
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::Remove
      include ::Shoes::BackendDimensionsDelegations

      def_delegators :dsl, :angle, :outer, :inner, :points

      attr_reader :dsl, :app, :transform, :container

      def initialize(dsl, app)
        @dsl = dsl
        @app = app
        @container = @app.real

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      class Painter < Common::Painter
        def fill(gc)
          gc.fillPolygon make_polygon(@obj)
        end

        def draw(gc)
          gc.drawPolygon make_polygon(@obj)
        end

        def make_polygon(obj)
          outer, inner, points, left, top = obj.outer, obj.inner, obj.points,
                                            obj.element_left, obj.element_top
          polygon = []
          polygon << left << (top + outer)
          (1..points * 2).each do |i|
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
