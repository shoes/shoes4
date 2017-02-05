# frozen_string_literal: true
class Shoes
  module Swt
    class Arc
      include Common::Clickable
      include Common::Fill
      include Common::Stroke
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::Remove
      include Common::Translate
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :app, :transform

      # Creates a new Shoes::Swt::Arc
      #
      # @param [Shoes::Arc] dsl The DSL object represented by this implementation
      # @param [Shoes::Swt::App] app The implementation object of the Shoes app
      def initialize(dsl, app)
        @dsl = dsl
        @app = app

        @painter = ArcPainter.new(self)
        @app.add_paint_listener @painter
      end

      def angle1
        radians_to_degrees dsl.angle1
      end

      def angle2
        radians_to_degrees dsl.angle2
      end

      def wedge?
        dsl.wedge?
      end

      private

      def radians_to_degrees(radians)
        radians * 180 / ::Shoes::PI
      end
    end
  end
end
