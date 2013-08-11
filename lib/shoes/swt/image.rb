class Shoes
  module Swt
    class Image
      import java.io.ByteArrayInputStream

      include Common::Child
      include Common::Move
      include Common::Resource
      include Common::Clickable
      include Common::Toggle
      include Common::Clear

      BINARY_ENCODING = Encoding.find('binary')

      attr_reader :parent, :real, :dsl, :container, :painter
      attr_accessor :width, :height

      def initialize(dsl, parent, blk)
        @dsl = dsl
        @app = @parent = parent
        @left, @top = @dsl.left, @dsl.top
        @container = @parent.real

        load_image(@dsl.file_path)

        parent.dsl.contents << @dsl

        add_paint_listener

        clickable blk if blk
      end

      def update_image
        load_image(@dsl.file_path)
      end

      private
      def load_image(name_or_data)
        if url?(name_or_data)
          display_temporary_download_image
          download_and_display_real_image(name_or_data)
        else
          display_image(name_or_data)
        end
      end

      def url?(name_or_data)
        name_or_data =~ /^(http|https):\/\//
      end

      def display_temporary_download_image
        temporary_download_image = File.join(DIR, 'static/downloading.png')
        create_image(temporary_download_image)
      end

      def create_image(data)
        @real        = ::Swt::Graphics::Image.new(::Swt.display, data)
        @full_width  = @real.getImageData.width
        @full_height = @real.getImageData.height
        @width       = @dsl.opts[:width] || default_width
        @height      = @dsl.opts[:height] || default_height
      end

      def default_width
        if dsl.opts[:height]
          ratio = dsl.opts[:height] / @full_height
          @full_width * ratio
        else
          @full_width
        end
      end

      def default_height
        if dsl.opts[:width]
          ratio = dsl.opts[:width] / @full_width
          @full_height * ratio
        else
          @full_height
        end
      end

      def download_and_display_real_image(url)
        @tmpname = File.join(Dir.tmpdir, "__shoes4_#{Time.now.to_f}.png") unless @tmpname_or_data
        @dsl.app.download url, save: @tmpname do
          create_image @tmpname
        end
      end

      def display_image(name_or_data)
        if raw_image_data?(name_or_data)
          data = load_raw_image_data(name_or_data)
        else
          data = name_or_data
        end
        create_image(data)
      end

      def raw_image_data?(name_or_data)
        name_or_data.encoding == BINARY_ENCODING
      end

      def load_raw_image_data(name_or_data)
        stream = ByteArrayInputStream.new(name_or_data.to_java_bytes)
        begin
          data = ::Swt::Graphics::ImageLoader.new.load(stream).first
        rescue ::Swt::SWTException
          data = name_or_data
        end
        data
      end

      def add_paint_listener
        @painter = lambda do |event|
          gc = event.gc
          gc.drawImage @real, 0, 0, @full_width, @full_height, @left, @top, @width, @height unless @dsl.hidden
        end
        @container.add_paint_listener(@painter)
      end

    end
  end
end
