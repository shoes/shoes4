module Shoes
  module Mock
    class Line
      include Shoes::Mock::CommonMethods

      attr_accessor :width, :height

      def initialize(dsl, opts = nil)
        @dsl = dsl

        @left = opts[:left]
        @top = opts[:top]
        @width = opts[:width]
        @height = opts[:height]
      end
    end
  end
end
