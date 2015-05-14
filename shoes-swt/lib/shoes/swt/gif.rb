class Shoes
  module Swt
    class Gif
      import java.io.ByteArrayInputStream

      include Common::Child
      include Common::Resource
      include Common::Clickable
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::Remove
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :parent, :real, :dsl, :painter

      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent
        update_gif
        add_paint_listener
      end

      def update_gif
        load_gif(@dsl.file_path)
      end

      private

      def load_gif(name_or_data)
        if url?(name_or_data)
          save_width_and_height
          display_temporary_download_gif
          download_and_display_real_gif(name_or_data)
        else
          display_gif(name_or_data)
        end
      end

      def url?(name_or_data)
        @dsl.url?(name_or_data)
      end

      def save_width_and_height
        @saved_width  = dsl.element_width
        @saved_height = dsl.element_height
      end

      def display_temporary_download_gif
        temporary_download_gif = File.join(DIR, 'static/downloading.gif')
        create_gif(temporary_download_gif)
      end

      def create_gif(data)
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

      def download_and_display_real_gif(url)
        @tmpname = File.join(Dir.tmpdir, "__shoes4_#{Time.now.to_f}.gif") unless @tmpname_or_data
        @dsl.app.download url, save: @tmpname do
          restore_width_and_height
          create_gif @tmpname
        end
      end

      def restore_width_and_height
        dsl.element_width  = @saved_width
        dsl.element_height = @saved_height
      end

      def display_gif(name_or_data)
        loader = ::Swt::Graphics::ImageLoader.new
        data = load_raw_gif_data(loader, name_or_data)

        create_gif(data[0])

        if data.length > 1 and loader.repeatCount >= 0

          Thread.new {
            frame_nr = 0
            repeat_count = loader.repeatCount
            # repeat constantly (loader.repeatCount==0) or repeat_count times
            while loader.repeatCount == 0 or repeat_count > 0
              ::Swt.display.asyncExec do
                create_gif(data[frame_nr])
                app.redraw
              end
              begin
                sleep(data[frame_nr].delayTime.to_f/60)
              rescue Exception => e
                puts e.message
              end
              if loader.repeatCount != 0 and frame_nr == data.length - 1
                --repeat_count
              end
              frame_nr = (frame_nr+1)%data.length
            end
          }
        end
      end

      def raw_gif_data?(name_or_data)
        @dsl.raw_gif_data?(name_or_data)
      end

      def load_raw_gif_data(loader, name_or_data)
        begin
          data = loader.load(name_or_data)
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
