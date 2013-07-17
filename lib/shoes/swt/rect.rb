class Shoes
  module Swt
    class Rect
      include Common::Fill
      include Common::Stroke
      include Common::Move
      include Common::Clickable
      include Common::Toggle
      include Common::Clear

      def initialize(dsl, app, left, top, width, height, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @left = left
        @top = top
        @width = width
        @height = height
        @opts = opts
        @corners = opts[:curve] || 0
        @angle = opts[:angle] || app.dsl.rotate

        # Move
        @container = @app.real

        @painter = RectPainter.new(self)
        @app.add_paint_listener @painter
        clickable blk if blk
      end

      attr_reader :dsl, :angle
      attr_reader :app
      attr_reader :transform
      attr_reader :painter
      attr_accessor :left, :top, :width, :height
      attr_reader :corners
    end
  end
end
