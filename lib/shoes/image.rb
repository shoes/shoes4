class Shoes
  class Image
    include CommonMethods
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :parent, :blk, :gui, :app, :file_path, :opts, :dimensions

    def initialize(app, parent, file_path, opts = {}, blk = nil)
      @app = app
      @parent = parent
      @file_path = file_path
      @opts = opts
      @blk = blk
      parent.add_child self

      @dimensions = Dimensions.new opts

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
