class Shoes
  class Image
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui
    style_with :art_styles, :common_styles, :dimensions, :file_path

    def initialize(app, parent, file_path, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init styles, file_path: file_path
      @dimensions = Dimensions.new parent, @style
      @parent.add_child self
      @gui = Shoes.configuration.backend_for self, @parent.gui
      register_click blk
    end

    def path
      @style[:file_path]
    end

    def path=(path)
      style(file_path: path)
      @gui.update_image
    end
  end
end
