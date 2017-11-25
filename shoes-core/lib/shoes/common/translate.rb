# frozen_string_literal: true

class Shoes
  module Common
    module Translate
      def translate_left
        @translate_left ||= begin
                              left, _ = translate
                              left || 0
                            end
      end

      def translate_top
        @translate_top ||= begin
                             _, top = translate
                             top || 0
                           end
      end

      def clear_translate
        @translate_left = nil
        @translate_top = nil
      end
    end
  end
end
