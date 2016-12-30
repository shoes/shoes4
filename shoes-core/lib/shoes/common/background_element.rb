class Shoes
  module Common
    module BackgroundElement
      include Common::UIElement

      # Modules that muck with class methods need to be included like this
      #
      # We also can't rely on Common::UIElement providing these, as it gets
      # BackgroundElement, not the destination class to add things to!
      def self.included(base)
        base.include Common::Style
      end

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
