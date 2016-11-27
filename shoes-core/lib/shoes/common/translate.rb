class Shoes
  module Common
    module Translate
      def translate_left
        left, = translate
        left || 0
      end

      def translate_top
        _, top = translate
        top || 0
      end

      def translate
        style[:translate]
      end
    end
  end
end
