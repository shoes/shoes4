class Shoes
  module Swt
    class Rect
      extend Forwardable
      include Common::Fill
      include Common::Stroke
      include Common::Clickable
      include Common::Toggle
      include Common::Clear
      include ::Shoes::BackendDimensionsDelegations

      def_delegators :dsl, :angle, :corners


      attr_reader :dsl, :app, :transform, :painter, :container

      def initialize(dsl, app, opts ={}, &blk)
        @dsl = dsl
        @app = app
        @opts = opts

        @container = @app.real

        @painter = RectPainter.new(self)
        @app.add_paint_listener @painter
        clickable blk if blk
      end
    end
  end
end
