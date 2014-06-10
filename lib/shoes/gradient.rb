class Shoes
  class Gradient
    include Common::Inspect

    def initialize(color1, color2, alpha = Shoes::Color::OPAQUE)
      @color1, @color2 = color1, color2
      @alpha = alpha
    end

    attr_reader :alpha, :color1, :color2

    def inspect
      super.insert(-2, " #{color1}->#{color2}")
    end

    def ==(other)
      other.is_a?(self.class) && self.to_s == other.to_s
    end
  end
end
