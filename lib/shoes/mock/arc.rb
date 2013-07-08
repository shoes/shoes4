class Shoes
  module Mock
    class Arc
      def initialize(dsl, app, left, top, width, height, opts = {})
        @dsl, @app = dsl, app
        @left, @top, @width, @height = left, top, width, height
      end

      attr_reader :width, :height
    end
  end
end
