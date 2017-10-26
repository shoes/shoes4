# frozen_string_literal: true
class Shoes
  module Common
    class BackgroundElement < Common::UIElement
      def create_dimensions(*_)
        @dimensions = ParentDimensions.new @parent, @style
      end

      def painted?
        true
      end

      # We derive everything from our parent, so we skip slot positioning.
      def needs_positioning?
        false
      end

      def takes_up_space?
        false
      end

      def translate_left
        0
      end

      def translate_top
        0
      end
    end
  end
end
