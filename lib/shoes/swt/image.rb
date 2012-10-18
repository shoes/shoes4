module Shoes
  module Swt
    class Image
      include Common::Child
      include Common::Move
      include Common::Resource
      include Common::Clickable
      include Common::Toggle

      attr_reader :parent, :real, :dsl, :container, :paint_callback, :width, :height

      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @left, @top = @dsl.left, @dsl.top
        @container = @parent.real

        @real = ::Swt::Graphics::Image.new(::Swt.display, @dsl.file_path)
        @width, @height = @real.getImageData.width, @real.getImageData.height

        parent.dsl.contents << @dsl

        @paint_callback = lambda do |event|
          gc = event.gc
          gcs_reset gc
          gc.drawImage @real, @left, @top unless @dsl.hidden
        end
        @container.add_paint_listener(@paint_callback)

        clickable dsl, blk
      end
    end
  end
end
