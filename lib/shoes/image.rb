class Shoes
  class Image
    include CommonMethods
    include Common::Clickable

    attr_reader :parent, :blk, :gui, :app, :hidden, :file_path, :opts
    attr_accessor :left, :top

    def initialize(app, parent, file_path, opts = {}, blk = nil)
      @app = app
      @parent = parent
      @file_path = file_path
      @opts = opts
      @blk = blk

      @left = opts[:left] ? opts[:left] : 0
      @top = opts[:top] ? opts[:top] : 0

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)

      clickable_options(opts)
    end

    def path
      @file_path
    end

    def path=(path)
      @file_path = path
      @gui.update_image
    end
  end
end
