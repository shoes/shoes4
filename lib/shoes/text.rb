class Shoes
  class Text
    def initialize str, color=nil
      @str, @color = str, color
      @to_s = str.map(&:to_s).join
    end
    attr_reader :to_s, :style, :str, :color
    attr_accessor :parent
    def app
      @parent.app
    end
  end
end
