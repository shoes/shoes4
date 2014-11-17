class Shoes
  class Gradient
    include Common::Inspect
    include Comparable

    def initialize(color1, color2, alpha = Shoes::Color::OPAQUE)
      @color1, @color2 = color1, color2
      @alpha = alpha
    end

    attr_reader :alpha, :color1, :color2

    def inspect
      super.insert(-2, " #{color1}->#{color2}")
    end

    def <=>(other) # arbitrarily compare 1st non-equal color
      raise_class_mismatch_error(other) unless other.is_a?(self.class)
      if @color1 == other.color1
        @color2 <=> other.color2
      else
        @color1 <=> other.color1
      end
    end

    def raise_class_mismatch_error(other)
      fail ArgumentError,
           "can't compare #{self.class.name} with #{other.class.name}"
    end
  end
end
