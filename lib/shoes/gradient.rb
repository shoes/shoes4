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

    def <=>(other) #arbitrarily compare 1st non-equal color
      raise_class_mismatch_error(other) unless other.is_a?(self.class)
      if @color1 == other.color1
        compare_colors(@color2,other.color2)
      else
        compare_colors(@color1, other.color1)
      end
    end

    def compare_colors(color_a, color_b)
      sum_a = color_a.red * 10**6 + color_a.blue * 10**3 + color_a.green + color_b.alpha
      sum_b = color_b.red * 10**6 + color_b.blue * 10**3 + color_b.green + color_b.alpha
      sum_a > sum_b ? 1 : -1
    end

    def raise_class_mismatch_error other
      raise ArgumentError,
      "can't compare #{self.class.name} with #{other.class.name}"
    end
  end
end
