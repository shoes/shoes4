require 'shoes/swt/rect'

module Shoes
  module Swt
    class Background
      include Common::Fill
      include Common::Stroke
      include Common::Clear

      def initialize(dsl, app, left, top, width, height, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @container = @app.real
        @left = left
        @top = top
        @width = width
        @height = height
        @opts = opts
        @corners = opts[:curve] || 0
        
        dsl.parent.contents << @dsl

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      attr_reader :dsl
      attr_reader :transform
      attr_reader :painter
      attr_reader :opts
      attr_reader :corners
      attr_accessor :left, :top, :width, :height

      class Painter < Rect::Painter
        def fill(gc)
          set_position_and_size
          super
        end

        def draw(gc)
          # do nothing
        end
      end
    end
  end
end
