class Shoes
  class Span < Text
    def initialize str, options={}
      @opts = options
      super :span, str
    end

    def opts
      if @parent
        @parent.opts.merge(@opts)
      else
        @opts
      end
    end
  end
end
