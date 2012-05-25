module Shoes
  module Common
    module Paint
      DEFAULTS = {
        :stroke => Shoes::COLORS[:black],
        :fill   => Shoes::COLORS[:black]
      }

      def stroke
        @style[:stroke]
      end

      def stroke=(color)
        @style[:stroke] = color
      end

      def fill
        @style[:fill]
      end

      def fill=(color)
        @style[:fill] = color
      end
    end
  end
end
