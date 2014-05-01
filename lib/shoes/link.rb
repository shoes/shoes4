class Shoes
  class Link < Span
    attr_reader :app, :parent, :gui

    DEFAULT_OPTS = { underline: true, stroke: ::Shoes::COLORS[:blue] }

    def initialize(app, parent, texts, opts={}, &blk)
      @app = app
      @parent = parent
      setup_block(blk, opts)

      opts = DEFAULT_OPTS.merge(opts)
      @gui = Shoes.backend_for(self, opts)

      super texts, opts
    end

    def setup_block(blk, opts)
      if blk
        @blk = blk
      elsif opts.include?(:click)
        if opts[:click].respond_to?(:call)
          @blk = opts[:click]
        else
          # Slightly awkward, but we need App, not InternalApp, to call visit
          @blk = Proc.new { app.app.visit(opts[:click]) }
        end
      end
    end

    def click(&blk)
      @blk = blk
      self
    end

    def execute_link
      @blk.call
    end

    def in_bounds?(x, y)
      @gui.in_bounds?(x, y)
    end

    def clear
      @gui.clear
    end

  end
end
