class Shoes
  module Swt
    class Image
      import java.io.ByteArrayInputStream

      include Common::Child
      include Common::Resource
      include Common::Clickable
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::Remove
      include ::Shoes::BackendDimensionsDelegations

      BINARY_ENCODING = Encoding.find('binary')

      attr_reader :parent, :real, :dsl, :painter

      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent

        load_image(@dsl.file_path)

        add_paint_listener
      end

      def update_image
        load_image(@dsl.file_path)
      end

      private

      def load_image(name_or_data)
        if url?(name_or_data)
          save_width_and_height
          display_temporary_download_image
          download_and_display_real_image(name_or_data)
        else
          display_image(name_or_data)
        end
      end

      def url?(name_or_data)
        name_or_data =~ /^(http|https):\/\//
      end

      def save_width_and_height
        @saved_width  = dsl.element_width
        @saved_height = dsl.element_height
      end

      def display_temporary_download_image
        temporary_download_image = File.join(DIR, 'static/downloading.png')
        create_image(temporary_download_image)
      end

      def create_image(data)
        @real = ::Swt::Graphics::Image.new(::Swt.display, data)
        @full_width        = @real.getImageData.width
        @full_height       = @real.getImageData.height
        dsl.element_width  ||= default_width
        dsl.element_height ||= default_height
      end

      def default_width
        if dsl.element_height
          ratio = dsl.element_height.to_r / @full_height
          (@full_width * ratio).to_i
        else
          @full_width
        end
      end

      def default_height
        if dsl.element_width
          ratio = dsl.element_width.to_r / @full_width
          (@full_height * ratio).to_i
        else
          @full_height
        end
      end

      def download_and_display_real_image(url)
        @tmpname = File.join(Dir.tmpdir, "__shoes4_#{Time.now.to_f}.png") unless @tmpname_or_data
        @dsl.app.download url, save: @tmpname do
          restore_width_and_height
          create_image @tmpname
        end
      end

      def restore_width_and_height
        dsl.element_width  = @saved_width
        dsl.element_height = @saved_height
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
          graphics_context = event.gc
          graphics_context.drawImage @real, 0, 0, @full_width, @full_height, dsl.element_left, dsl.element_top, dsl.element_width, dsl.element_height unless @dsl.hidden
        end
        app.add_paint_listener(@painter)
      end
    end
  end
end
