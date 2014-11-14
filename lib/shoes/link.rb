class Shoes
  class Link < Span
    include Common::Style

    attr_reader :app, :parent, :gui, :blk
    style_with :common_styles, :text_block_styles
    STYLES = { underline: true, stroke: ::Shoes::COLORS[:blue], fill: nil }

    def initialize(app, parent, texts, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init styles
      @gui = Shoes.backend_for self

      setup_click blk
      super texts, @style
    end

    # Doesn't use Common::Clickable because of URL flavor option clicks
    def setup_click(blk)
      if blk.nil?
        if @style[:click].respond_to? :call
          blk = @style[:click]
        else
          # Slightly awkward, but we need App, not InternalApp, to call visit
          blk = proc { app.app.visit @style[:click] }
        end
      end

      click &blk
    end

    def click(&blk)
      @gui.click blk if blk
      @blk = blk
    end

    def pass_coordinates?
      false
    end

    def in_bounds?(x, y)
      @gui.in_bounds?(x, y)
    end

    def remove
      @gui.remove
    end

    def hidden?
      @text_block.hidden?
    end

    def visible?
      @text_block.visible?
    end
  end
end
