module Shoes
  module Mock
    class Arc
      def initialize(dsl, opts)
        @width = opts[:width]
        @height = opts[:height]
      end

      attr_reader :width, :height
    end
  end
end
