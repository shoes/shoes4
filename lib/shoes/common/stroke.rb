module Shoes
  module Common
    # Methods for objects with stroke
    #
    # @note Including classes must provide `#style`
    module Stroke
      DEFAULTS = {
        :stroke => Shoes::COLORS[:black],
        :strokewidth => 1
      }

      def stroke
        style[:stroke]
      end

      def stroke=(color)
        style[:stroke] = color
      end

      def strokewidth
        style[:strokewidth]
      end

      def strokewidth=(width)
        style[:strokewidth] = width
      end
    end
  end
end
