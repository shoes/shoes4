# frozen_string_literal: true

require 'fileutils'

class Shoes
  module Swt
    class Image
      import java.io.ByteArrayInputStream

      include Common::Resource
      include Common::Clickable
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::Remove
      include Common::ImageHandling
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :app, :real, :dsl, :painter, :full_width, :full_height

      def initialize(dsl, app)
        @dsl = dsl
        @app = app
        @tmpname_or_data = nil
        update_image

        @painter = ImagePainter.new(self)
        app.add_paint_listener(@painter)
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
        @dsl.url?(name_or_data)
      end

      def save_width_and_height
        @saved_width  = dsl.element_width
        @saved_height = dsl.element_height
      end

      def display_temporary_download_image
        temporary_download_image = File.join(DIR, 'static/downloading.png')
        create_image(load_file_image_data(temporary_download_image))
      end

      def create_image(data)
        @real = ::Swt::Graphics::Image.new(::Swt.display, data)
        @full_width        = @real.getImageData.width
        @full_height       = @real.getImageData.height
        dsl.element_width  ||= default_width
        dsl.element_height ||= default_height

        cleanup_temporary_files
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
        data = if raw_image_data?(name_or_data)
                 load_raw_image_data(name_or_data)
               else
                 load_file_image_data(name_or_data)
               end
        create_image(data)
      end

      def raw_image_data?(name_or_data)
        @dsl.raw_image_data?(name_or_data)
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
    end
  end
end
