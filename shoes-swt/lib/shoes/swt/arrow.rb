# frozen_string_literal: true
class Shoes
  module Swt
    class Arrow
      extend Forwardable
      include Common::Fill
      include Common::Stroke
      include Common::Clickable
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::Remove
      include Common::Translate
      include ::Shoes::BackendDimensionsDelegations

      def_delegators :dsl, :angle

      attr_reader :dsl, :app, :transform, :path, :painter

      def initialize(dsl, app)
        @dsl = dsl
        @app = app

        @painter = ArrowPainter.new(self)
        @app.add_paint_listener @painter
      end

      def update_position
        @painter.clear_path
      end

      def dispose
        @painter.dispose
      end
    end
  end
end
