class Shoes
  module Common
    module BackgroundElement
      def create_dimensions(*_)
        @dimensions = ParentDimensions.new @parent, @style
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
