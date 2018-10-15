# frozen_string_literal: true

class Shoes
  class Link < Span
    include Common::Fill
    include Common::Hover
    include Common::SafelyEvaluate
    include Common::Stroke
    include Common::Style

    attr_reader :app, :gui, :blk
    style_with :common_styles, :text_block_styles
    STYLES = { underline: true, stroke: ::Shoes::COLORS[:blue], fill: nil }.freeze

    def initialize(my_app, texts, styles = {}, blk = nil)
      @app = my_app
      style_init styles
      @gui = Shoes.backend_for self

      register_click blk
      super texts, @style
    end

    # Doesn't use Common::Clickable because of URL flavor option clicks
    def register_click(blk)
      if blk.nil?
        blk = if @style[:click].respond_to? :call
                @style[:click]
              else
                # Slightly awkward, but we need App, not InternalApp, to call visit
                proc { app.app.visit @style[:click] }
              end
      end

      click(&blk)
    end

    def click(&blk)
      @gui.click blk if blk
      @blk = blk
      self
    end

    def release(&blk)
      @gui.release blk if blk
      self
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

    def links
      [self]
    end

    private

    def text_block_guard
      if @text_block
        true
      else
        Shoes.logger.warn '`link` was called but not passed to a `para` or `title`. Please make sure all your `link` calls have a home in another text element!'
        false
      end
    end
  end
end
