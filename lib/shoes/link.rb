class Shoes
  class Link < Span
    attr_reader :app, :gui, :blk

    DEFAULT_OPTS = { underline: true, fg: ::Shoes::COLORS[:blue] }

    def initialize texts, color=nil, opts={}, &blk
      @blk = blk
      @app = opts.delete(:app)
      opts = DEFAULT_OPTS.merge(opts).merge(:color => color)
      super texts, opts

      @gui = Shoes.backend_for(self, opts)
    end

  end
end
