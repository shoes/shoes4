class Shoes
  class Link < Span
    include Common::Style

    attr_reader :app, :gui, :blk
    style_with :common_styles, :text_block_styles
    STYLES = { underline: true, stroke: ::Shoes::COLORS[:blue], fill: nil }

    def initialize(my_app, texts, styles = {}, blk = nil)
      @app = my_app
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

      click(&blk)
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
      text_block_guard && @text_block.hidden?
    end

    def visible?
      text_block_guard && @text_block.visible?
    end

    private

    def text_block_guard
      if @text_block
        true
      else
        @app.warn 'Stray link without TextBlock detected! Links have to be part of a text block like a para or title'
        false
      end
    end
  end
end
