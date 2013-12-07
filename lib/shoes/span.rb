class Shoes
  class Span < Text
    def initialize str, options={}
      @opts = options
      super str
    end

    def opts
      if @parent && @parent.respond_to?(:opts)
        @parent.opts.merge(@opts)
      else
        @opts
      end
    end
  end
end
