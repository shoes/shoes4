require 'shoes/common_methods'
require 'shoes/common/stroke'
require 'shoes/common/style'

module Shoes
  module Swt
    class Curve
      include Common::Stroke
      include Common::Move
      include Common::Toggle
      include Common::Clear

      # @param [Shoes::Curve] the {Shoes::Curve} implemented by this object
      # @param [Shoes::Swt::App] app the {Swt::App} this object belongs to
      def initialize(dsl, app, x1, y1, x2, y2, x3, y3, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @container = @app.real
        @x1 = x1
        @y1 = y1
        @x2 = x2
        @y2 = y2
        @x3 = x3
        @y3 = y3
        @angle = opts[:angle] || 0

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      attr_reader :dsl, :app
      attr_reader :x1, :y1, :x2, :y2, :x3, :y3
      attr_reader :transform

      def move(x, y)
        self
      end

      class Painter < Common::Painter
        def draw(gc)
        end

        def fill_setup(gc)
        end
      end
    end
  end
end
