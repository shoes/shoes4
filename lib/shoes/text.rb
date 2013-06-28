class Shoes
  class Text
    def initialize m, str, color=nil
      @style, @str, @color = m, str, color
      @to_s = str.map(&:to_s).join
    end
    attr_reader :to_s, :style, :str, :color
    attr_accessor :parent
    def app
      @parent.app
    end
  end
  
  class Link < Text
    def initialize m, str, color=nil, &blk
      @blk = blk
      super m, str, color
    end
    attr_reader :blk
    attr_accessor :click_listener, :lh, :sx, :sy, :ex, :ey, :pl, :pt, :pw, :ph,
                  :clickabled, :parent
    
    def in_bounds?(x, y)
      ((pl..(pl+pw)).include?(x) and (sy..ey).include?(y) and !((pl..sx).include?(x) and (sy..(sy+lh)).include?(y)) and !((ex..(pl+pw)).include?(x) and ((ey-lh)..ey).include?(y)))
    end
  end
end
