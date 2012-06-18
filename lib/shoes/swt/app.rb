require 'swt'
require 'shoes/swt/background_painter'

module Shoes
  module Swt
    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #
    class App
      include Common::Container
      def initialize dsl
        @dsl = dsl
        @real = ::Swt::Widgets::Shell.new(::Swt.display, main_window_style).tap do |shell|
          layout = ::Swt::Layout::RowLayout.new
          shell.set_image ::Swt::Graphics::Image.new(::Swt.display, SHOES_ICON)
          shell.setLayout(layout)
          shell.setSize(@dsl.width, @dsl.height)
          shell.setText(@dsl.title)
          shell.addListener(::Swt::SWT::Close, main_window_on_close)
        end
        background Array(@dsl.background)
      end

      attr_reader :background
      attr_reader :real

      def open
        @real.open

        ::Swt.event_loop { ::Swt.display.isDisposed }

        Shoes.logger.debug "::Swt.display disposed... exiting Shoes::App.new"
      end

      # gui_background will set the background to the
      # value passed to it through opts.
      # It will accept either a Shoes::Color object or
      # a Shoes::Color object along with some additional
      # options.
      def background(opts)
        # Duplicates logic in Shoes::App
        if opts.size == 1
          @real.setBackground(opts[0].to_native)
        else
          @real.addPaintListener(BackgroundPainter.new(opts, @dsl))
        end
      end

      # @return [Shoes::Swt::App] Self
      def app
        self
      end

      private
      def main_window_on_close
        lambda { |event|
          Shoes.logger.debug "main_window on_close block begin... disposing ::Swt.display"
          ::Swt.display.dispose
          Shoes.logger.debug "::Swt.display disposed"
        }
      end

      def main_window_style
        style  = ::Swt::SWT::CLOSE | ::Swt::SWT::MIN | ::Swt::SWT::MAX
        style |= ::Swt::SWT::RESIZE if @dsl.opts[:resizable]
        style
      end
    end
  end
end


