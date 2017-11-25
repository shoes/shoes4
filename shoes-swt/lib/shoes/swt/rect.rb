# frozen_string_literal: true

class Shoes
  module Swt
    class Rect
      extend Forwardable
      include Common::Fill
      include Common::Stroke
      include Common::Clickable
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::Remove
      include Common::Translate
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :app, :transform, :painter

      def initialize(dsl, app)
        @dsl = dsl
        @app = app

        @painter = RectPainter.new(self)
        @app.add_paint_listener @painter
      end

      def corners
        dsl.curve
      end
    end
  end
end
