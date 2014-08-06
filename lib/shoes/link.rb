class Shoes
  class Link < Span

    include Common::Style

    attr_reader :app, :parent, :gui, :blk
    style_with :text_block_styles
    STYLES = { underline: true, stroke: ::Shoes::COLORS[:blue], fill: nil }

    def initialize(app, parent, texts, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init(styles)
      setup_block(blk, @style)
      @gui = Shoes.backend_for(self, @style)

      super texts, @style
    end

    def setup_block(blk, style)
      if blk
        @blk = blk
      elsif style.include?(:click)
        if style[:click].respond_to?(:call)
          @blk = style[:click]
        else
          # Slightly awkward, but we need App, not InternalApp, to call visit
          @blk = Proc.new { app.app.visit(style[:click]) }
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

    def remove
      @gui.remove
    end

  end
end
