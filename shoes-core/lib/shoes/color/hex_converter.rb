# frozen_string_literal: true
class Shoes
  class Color
    class HexConverter
      def initialize(hex)
        @hex = validate(hex) || raise(ArgumentError, "Bad hex color: #{hex}")
        @red, @green, @blue = hex_to_rgb(pad_if_necessary(@hex))
      end

      def to_rgb
        [@red, @green, @blue]
      end

      private

      def hex_to_rgb(hex)
        hex.chars.each_slice(2).map { |a| a.join.to_i(16) }
      end

      def pad_if_necessary(hex)
        return hex unless hex.length == 3
        hex.chars.map { |c| "#{c}#{c}" }.join
      end

      # Returns a 3- or 6-char hex string for valid input, or nil
      # for invalid input.
      def validate(hex)
        match = /^#?(([0-9a-f]{3}){1,2})$/i.match(hex)
        match && match[1]
      end
    end
  end
end
