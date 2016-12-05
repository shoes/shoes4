class Shoes
  module Swt
    class Oval
      include Common::Fill
      include Common::Stroke
      include Common::Clickable
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::Remove
      include Common::Translate
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :app, :transform, :painter, :container

      # @param [Shoes::Oval] dsl the dsl object to provide gui for
      # @param [Shoes::Swt::App] app the app
      # @param [Hash] opts options
      def initialize(dsl, app)
        @dsl = dsl
        @app = app
        @container = @app.real

        @painter = OvalPainter.new(self)
        @app.add_paint_listener @painter
      end

      def update_position
        # No-op, since it has its own painter
      end
    end
  end
end
