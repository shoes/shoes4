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

        load_image(@dsl.file_path)

        parent.dsl.contents << @dsl

        @painter = lambda do |event|
          gc = event.gc
          gc.drawImage @real, 0, 0, @full_width, @full_height, @left, @top, @width, @height unless @dsl.hidden
        end
        @container.add_paint_listener(@painter)

        clickable blk if blk
      end

      def load_image(name)
        if name =~ /^(http|https):\/\//
          @tmpname = File.join(Dir.tmpdir, "__shoes4_#{Time.now.to_f}.png") unless @tmpname
          url, name = name, File.join(DIR, 'static/downloading.png')
        end

        @real = ::Swt::Graphics::Image.new(::Swt.display, name)
        @full_width, @full_height = @real.getImageData.width, @real.getImageData.height
        @width = @dsl.opts[:width] || @full_width
        @height = @dsl.opts[:height] || @full_height

        @dsl.app.download url, save: @tmpname do
          @real = ::Swt::Graphics::Image.new Shoes.display, @tmpname
          @full_width, @full_height = @real.getImageData.width, @real.getImageData.height
          @width = @dsl.opts[:width] || @full_width
          @height = @dsl.opts[:height] || @full_height
        end if url
      end

      def update_image
        load_image(@dsl.file_path)
      end
    end
  end
end
