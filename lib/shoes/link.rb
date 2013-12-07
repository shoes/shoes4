class Shoes
  class Link < Text
    def initialize str, color=nil, &blk
      @blk = blk
      super str, color
    end
    attr_reader :blk
    attr_accessor :click_listener, :line_height, :start_x, :start_y,
                  :end_x, :end_y, :clickabled,
                  :parent

    def in_bounds?(x, y)
      (start_x..end_x).include?(x) and (start_y..end_y).include?(y)
    end
  end
end
