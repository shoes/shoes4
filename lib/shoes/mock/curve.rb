module Shoes
  module Mock
    class Curve
      include Shoes::Mock::CommonMethods

      def initialize(dsl, app, x1, y1, x2, y2, x3, y3, opts = {})
        @dsl, @app = dsl, app
        @x1, @y1, @x2, @y2, @x3, @y3 = x1, y1, x2, y2, x3, y3
      end

      attr_reader :x1, :y1, :x2, :y2, :x3, :y3
    end
  end
end
