class Shoes
  class Oval
    include Shoes::CommonMethods
    include Shoes::Common::Fill
    include Shoes::Common::Stroke
    include Shoes::Common::Style
    include Shoes::Common::Clickable

    def initialize(app, left, top, width, height, opts = {}, &blk)
      @app = app
      @left = left
      @top = top
      @width = width
      @height = height
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1
      @app.unslotted_elements << self

      # GUI
      @gui = Shoes.backend_for(self, left, top, width, height, opts, &blk)

      clickable_options(opts)
    end

    attr_reader :app, :hidden
  end
end
