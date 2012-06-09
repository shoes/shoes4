module Shoes
  module Common
    # Methods for objects with fill
    #
    # @note Including classes must provide `#style`
    module Fill
      DEFAULTS = {
        :fill   => Shoes::COLORS[:black]
      }

      def fill
        style[:fill]
      end

      def fill=(color)
        style[:fill] = color
      end
    end
  end
end

