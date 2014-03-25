class Shoes
  class Link < Span
    DEFAULT_OPTS = { underline: true, fg: ::Shoes::COLORS[:blue] }

    def initialize texts, color=nil, opts={}, &blk
      @blk = blk
      opts = DEFAULT_OPTS.merge(opts).merge(:color => color)
      super texts, opts
    end

    attr_reader :blk
    attr_accessor :click_listener, :line_height, :start_x, :start_y,
                  :end_x, :end_y, :clickabled

    def in_bounds?(x, y)
      (start_x..end_x).include?(x) and (start_y..end_y).include?(y)
    end
  end
end
