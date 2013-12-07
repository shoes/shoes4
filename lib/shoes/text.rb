class Shoes
  class Text
    def initialize texts, color=nil
      @texts = texts
      @color = color
      @to_s = @texts.map(&:to_s).join
    end
    attr_reader :to_s, :texts, :color
    attr_accessor :parent
    def app
      @parent.app
    end
  end
end
