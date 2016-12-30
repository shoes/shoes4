class Shoes
  module Common
    module ArtElement
      include Common::UIElement
      include Common::Clickable
      include Common::Rotate
      include Common::Translate

      def self.included(base)
        base.include Common::Hover
      end
    end
  end
end
