class Shoes
  module Mock
    class Rect
      include CommonMethods

      def initialize(dsl, app, left, top, width, height, opts = {})
        @dsl, @app = dsl, app
        @left, @top, @width, @height = left, top, width, height
      end

      attr_reader :dsl, :app
      attr_accessor :left, :top, :width, :height
    end
  end
end
