class Shoes
  class Image
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    BINARY_ENCODING = Encoding.find('binary')

    attr_reader :app, :parent, :dimensions, :gui
    style_with :art_styles, :common_styles, :dimensions, :file_path

    def initialize(app, parent, file_path_or_data, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init styles, file_path: normalized_source(file_path_or_data)
      @dimensions = Dimensions.new parent, @style
      @parent.add_child self
      @gui = Shoes.configuration.backend_for self, @parent.gui
      register_click blk
    end

    def path
      @style[:file_path]
    end

    def path=(path_or_data)
      style(file_path: normalized_source(path_or_data))
      @gui.update_image
    end

    def url?(path_or_data)
      path_or_data =~ %r{^https?://}
    end

    def raw_image_data?(name_or_data)
      name_or_data.encoding == BINARY_ENCODING
    end

    private

    def normalized_source(path_or_data)
      return path_or_data if raw_image_data?(path_or_data)
      return path_or_data if url?(path_or_data)
      absolute_file_path(path_or_data)
    end

    def absolute_file_path(path)
      path = File.join(Shoes::DIR, path) unless Pathname(path).absolute?
      fail FileNotFoundError, "#{path} not found." unless File.exist?(path)
      path
    end
  end
end
