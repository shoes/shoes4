# frozen_string_literal: true
class Shoes
  module Common
    module ArtElement
      include Common::UIElement
      include Common::Clickable
      include Common::Fill
      include Common::Rotate
      include Common::Stroke
      include Common::Translate

      # Modules that muck with class methods need to be included like this
      #
      # We also can't rely on Common::UIElement providing these, as it gets
      # ArtElement, not the destination class to add things to!
      def self.included(base)
        base.include Common::Hover
        base.include Common::Style
      end
    end
  end
end
