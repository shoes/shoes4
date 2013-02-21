module Shoes
  module Mock
    class Star
      include CommonMethods

      def initialize(dsl, app, left, top, points, outer, inner, opts = {})
        @dsl, @app = dsl, app
        @left, @top, @points, @outer, @inner = left, top, points, outer, inner
      end

      attr_reader :dsl, :app
      attr_reader :left, :top, :width, :height, :points, :outer, :inner
    end
  end
end
