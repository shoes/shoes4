require 'shoes/color'

module Shoes
  class Gradient
    def initialize(color1, color2, alpha = Shoes::Color::OPAQUE)
      @color1, @color2 = color1, color2
      @alpha = alpha
    end

    attr_reader :alpha, :color1, :color2

    def to_s
      "<#{self.class} #{color1.hex}->#{color2.hex}>"
    end

    def ==(other)
      other.is_a?(self.class) && self.to_s == other.to_s
    end
  end
end
