# frozen_string_literal: true
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
      include Common::Translate
      include ::Shoes::BackendDimensionsDelegations

      def_delegators :dsl, :angle, :outer, :inner, :points

      attr_reader :dsl, :app, :transform, :container

      def initialize(dsl, app)
        @dsl = dsl
        @app = app
        @container = @app.real

        @painter = StarPainter.new(self)
        @app.add_paint_listener @painter
      end
    end
  end
end
