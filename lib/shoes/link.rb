class Shoes
  class Link < Text
    def initialize m, str, color=nil, &blk
      @blk = blk
      super m, str, color
    end
    attr_reader :blk
    attr_accessor :click_listener, :line_height, :start_x, :start_y,
                  :end_x, :end_y, :parent_left, :parent_width, :clickabled,
                  :parent

    def in_bounds?(x, y)
      if parent_width
        (start_x..end_x).include?(x) and (start_y..end_y).include?(y)
      end
    end
  end
end
