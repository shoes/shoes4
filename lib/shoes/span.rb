class Shoes
  class Span < Text
    attr_reader :opts

    def initialize str, opts={}
      @opts = opts
      super :span, str
    end
  end
end
