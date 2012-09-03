module Shoes
  module Mock
    class Rect
      def initialize(dsl, app, left, top, width, height, opts = {})
        @dsl, @app = dsl, app
        @left, @top, @width, @height = left, top, width, height
      end

      attr_reader :dsl, :app
      attr_reader :left, :top, :width, :height
    end
  end
end
