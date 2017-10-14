# frozen_string_literal: true

class Shoes
  class Gradient
    include Common::Inspect
    include Comparable

    def initialize(color1, color2, alpha = Shoes::Color::OPAQUE)
      @color1 = color1
      @color2 = color2
      @alpha = alpha
    end

    attr_reader :alpha, :color1, :color2

    def <=>(other) # arbitrarily compare 1st non-equal color
      return unless other.is_a?(self.class)
      [color1, color2] <=> [other.color1, other.color2]
    end

    private

    def inspect_details
      " #{color1}->#{color2}"
    end
  end
end
