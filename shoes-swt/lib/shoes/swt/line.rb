class Shoes
  module Swt
    class Line
      include Common::Clickable
      include Common::Stroke
      include Common::Visibility
      include Common::Remove
      include Common::Translate
      include Common::PainterUpdatesPosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :app
      attr_reader :transform

      def initialize(dsl, app)
        @dsl = dsl
        @app = app

        @painter = LinePainter.new(self)
        @app.add_paint_listener(@painter)

        @transform = nil # Not necessary for this shape
      end

      def angle
        @dsl.angle
      end
    end
  end
end
