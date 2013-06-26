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
      def initialize(dsl, app, p1, p2, p3, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @container = @app.real

        @p1, @p2, @p3 = p1, p2, p3

        @angle = opts[:angle] || 0

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      attr_reader :dsl, :app
      attr_reader :p1, :p2, :p3
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
