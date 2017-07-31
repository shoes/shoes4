# frozen_string_literal: true
class Shoes
  class Color
    include Common::Inspect
    include Comparable

    OPAQUE = 255
    TRANSPARENT = 0

    def self.create(color)
      color.is_a?(Color) ? color : new(color)
    end

    def initialize(*args) # red, green, blue, alpha = OPAQUE)
      case args.length
      when 1
        red, green, blue, alpha = HexConverter.new(args.first).to_rgb
      when 3, 4
        red, green, blue, alpha = *args
      else
        message = <<EOS
Wrong number of arguments (#{args.length} for 1, 3, or 4).
Must be one of:
  - #{self.class}.new(hex_string)
  - #{self.class}.new(red, green, blue)
  - #{self.class}.new(red, green, blue, alpha)
EOS
        raise ArgumentError, message
      end
      alpha ||= OPAQUE
      @red = normalize_rgb(red)
      @green = normalize_rgb(green)
      @blue = normalize_rgb(blue)
      @alpha = normalize_rgb(alpha)
    end

    attr_reader :red, :green, :blue, :alpha

    def light?
      @red + @green + @blue > 510 # 0xaa * 3
    end

    def dark?
      @red + @green + @blue < 255 # 0x55 * 3
    end

    def transparent?
      @alpha == TRANSPARENT
    end

    def opaque?
      @alpha == OPAQUE
    end

    def white?
      @red == 255 && @green == 255 && @blue == 255
    end

    def black?
      @red.zero? && @green.zero? && @blue.zero?
    end

    def <=>(other)
      return nil unless other.is_a?(self.class)
      if same_base_color?(other)
        @alpha <=> other.alpha
      else
        less_or_greater_than other
      end
    end

    # @return [String] a hex represenation of this color
    # @example
    #   Shoes::Color.new(255, 0, 255).hex # => "#ff00ff"
    def hex
      format "#%02x%02x%02x", @red, @green, @blue
    end

    def to_s
      "rgb(#{red}, #{green}, #{blue})"
    end

    private

    def inspect_details
      " #{self} alpha:#{@alpha}"
    end

    def normalize_rgb(value)
      rgb = value.is_a?(Integer) ? value : (255 * value).round
      return 255 if rgb > 255
      return 0 if rgb.negative?
      rgb
    end

    def same_base_color?(other)
      @red == other.red && @green == other.green && @blue == other.blue
    end

    def less_or_greater_than(other)
      own_sum = @red + @green + @blue
      other_sum = other.red + other.green + other.blue
      if own_sum > other_sum
        1
      else
        -1
      end
    end
  end
end

require 'shoes/color/hex_converter'
require 'shoes/color/dsl_helpers'
require 'shoes/color/dsl'
