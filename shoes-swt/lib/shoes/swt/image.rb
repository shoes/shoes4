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

      attr_reader :parent, :real, :dsl, :painter

      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent
        @is_image = File.extname(@dsl.file_path) != ".gif"
        update_image
        add_paint_listener if @is_image
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
          display_image_or_gif(name_or_data)
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
        if @is_image
          @tmpname = File.join(Dir.tmpdir, "__shoes4_#{Time.now.to_f}.png") unless @tmpname_or_data
        else
          @tmpname = File.join(Dir.tmpdir, "__shoes4_#{Time.now.to_f}.gif") unless @tmpname_or_data
        end
        @dsl.app.download url, save: @tmpname do
          restore_width_and_height
          if @is_image
            create_image @tmpname
          else
            display_gif @tmpname
          end
        end
      end

      def restore_width_and_height
        dsl.element_width  = @saved_width
        dsl.element_height = @saved_height
      end

      def display_image_or_gif(name_or_data)
        if @is_image
          display_image(name_or_data)
        else
          display_gif(name_or_data)
        end
      end

      def display_image(name_or_data)
        if raw_image_data?(name_or_data)
          data = load_raw_image_data(::Swt::Graphics::ImageLoader.new, name_or_data)
        else
          data = name_or_data
        end
        create_image(data)
      end

      def display_gif(name_or_data)
        loader = ::Swt::Graphics::ImageLoader.new
        if raw_image_data?(name_or_data)
          data = load_raw_image_data(loader, name_or_data)
        else
          begin
            data = loader.load(name_or_data)
          rescue ::Swt::SWTException
            data = name_or_data
          end
        end

        create_image(data[0])

        Thread.new {
          frame_nr = 0
          repeat_count = loader.repeatCount
          frame = data[0]

          # repeat constantly (loader.repeatCount==0) or repeat_count times
          while loader.repeatCount == 0 or repeat_count > 0

            ::Swt.display.asyncExec do
              @off_screen_image = ::Swt::Graphics::Image.new(::Swt.display, loader.logicalScreenWidth, loader.logicalScreenHeight)
              @gc_shell = ::Swt::Graphics::GC.new(app.shell)
              @off_screen_img_gc = ::Swt::Graphics::GC.new(@off_screen_image)
              @off_screen_img_gc.setBackground(app.shell.getBackground)
              @off_screen_img_gc.fillRectangle(0, 0, loader.logicalScreenWidth, loader.logicalScreenHeight)
              @off_screen_img_gc.drawImage(::Swt::Graphics::Image.new(::Swt.display, frame), 0, 0, frame.width, frame.height, frame.x, frame.y, frame.width, frame.height)#dsl.element_width, dsl.element_height)

              #fill background if necessary
              if frame_nr == data.length - 1 || frame.disposalMethod == ::Swt::SWT::DM_FILL_BACKGROUND
                if loader.backgroundPixel != -1
                  bg_color = ::Swt::Graphics::Color.new(display, frame.palette.getRGB(loader.backgroundPixel))
                end
                #@off_screen_img_gc.setBackground(bg_color.nil? ? app.shell.getBackground : bg_color)
                @off_screen_img_gc.setBackground(app.shell.getBackground)
                @off_screen_img_gc.fillRectangle(frame.x, frame.y, frame.width, frame.height)
                bg_color.dispose if !bg_color.nil?
              elsif frame.disposalMethod == ::Swt::SWT::DM_FILL_PREVIOUS
                @off_screen_img_gc.drawImage(::Swt::Graphics::Image.new(::Swt.display, frame), 0, 0, frame.width, frame.height, frame.x, frame.y, frame.width, frame.height)#dsl.element_width, dsl.element_height)
              end

              frame_nr = (frame_nr+1)%data.length
              frame = data[frame_nr]
              #redraw frame
              @off_screen_img_gc.drawImage(::Swt::Graphics::Image.new(::Swt.display, frame), 0, 0, frame.width, frame.height, frame.x, frame.y, frame.width, frame.height)#dsl.element_width, dsl.element_height)
              @gc_shell.drawImage(@off_screen_image, 0, 0)
            end
            begin
              sleep(data[frame_nr].delayTime.to_f/60)
            rescue Exception => e
              puts e.message
            end
            --repeat_count if  loader.repeatCount != 0 and frame_nr == data.length - 1
          end
        }
      end

      def raw_image_data?(name_or_data)
        @dsl.raw_image_data?(name_or_data)
      end

      def load_raw_image_data(loader, name_or_data)
        stream = ByteArrayInputStream.new(name_or_data.to_java_bytes)
        begin
          data = @is_image ? loader.load(stream).first : loader.new.load(stream)
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
