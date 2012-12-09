module Shoes
  module Swt
    class Image
      include Common::Child
      include Common::Move
      include Common::Resource
      include Common::Clickable
      include Common::Toggle
      include Common::Clear

      attr_reader :parent, :real, :dsl, :container, :painter, :width, :height
      attr_accessor :ln

      def initialize(dsl, parent, blk)
        @dsl = dsl
        @app = @parent = parent
        @left, @top = @dsl.left, @dsl.top
        @container = @parent.real

        @real = ::Swt::Graphics::Image.new(::Swt.display, @dsl.file_path)
        @full_width, @full_height = @real.getImageData.width, @real.getImageData.height
        @width = @dsl.opts[:width] || @full_width
        @height = @dsl.opts[:height] || @full_height

        parent.dsl.contents << @dsl

        @painter = lambda do |event|
          gc = event.gc
          gcs_reset gc
          gc.drawImage @real, 0, 0, @full_width, @full_height, @left, @top, @width, @height unless @dsl.hidden
        end
        @container.add_paint_listener(@painter)

        clickable self, blk
      end
    end
  end
end
