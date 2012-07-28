module Shoes
  module Swt
    class Image
      include Common::Child
      include Common::Move

      attr_reader :parent, :real, :dsl, :container, :paint_callback

      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk
        @left, @top = @dsl.left, @dsl.top
        @container = @parent.real

        @real = ::Swt::Graphics::Image.new(::Swt.display, @dsl.file_path)
        @width, @height = @real.getImageData.width, @real.getImageData.height
        
        @dsl.width, @dsl.height = @width, @height
        parent.dsl.contents << @dsl
        
        @paint_callback = lambda do |event|
          gc = event.gc
          gc.drawImage @real, @left, @top
        end
        @container.add_paint_listener(@paint_callback)
      end
    end
  end
end
