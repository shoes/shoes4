class Shoes
  module Common
    module ArtElement
      include Common::UIElement
      include Common::Clickable
      include Common::Rotate
      include Common::Translate
    end
  end
end
