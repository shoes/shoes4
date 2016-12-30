class Shoes
  module Common
    module ArtElement
      include Common::UIElement
      include Common::Clickable
      include Common::Fill
      include Common::Rotate
      include Common::Stroke
      include Common::Translate

      def self.included(base)
        base.include Common::Hover
      end
    end
  end
end
