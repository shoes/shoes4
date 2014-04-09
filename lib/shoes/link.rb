class Shoes
  class Link < Span
    include CommonMethods

    attr_reader :app, :parent, :gui, :blk

    DEFAULT_OPTS = { underline: true, fg: ::Shoes::COLORS[:blue] }

    def initialize(app, parent, texts, opts={}, &blk)
      @app = app
      @parent = parent
      @blk = blk

      opts = DEFAULT_OPTS.merge(opts)
      @gui = Shoes.backend_for(self, opts)

      super texts, opts
    end

  end
end
