require 'swt'
require 'shoes/swt/background_painter'

module Shoes
  module Swt
    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #
    class App

      attr_reader :background

      def initialize app
        @app = app
        @app.gui_container = container = ::Swt::Widgets::Shell.new(::Swt.display, main_window_style)
        layout = ::Swt::Layout::RowLayout.new
        container.set_image ::Swt::Graphics::Image.new(::Swt.display, SHOES_ICON)
        container.setLayout(layout)

        container.setSize(app.width, app.height)
        container.setText(app.title)
        gui_background [@app.background]

        container.addListener(::Swt::SWT::Close, main_window_on_close)
      end


      def open
        @app.gui_container.open

        ::Swt.event_loop { ::Swt.display.isDisposed }

        Shoes.logger.debug "::Swt.display disposed... exiting Shoes::App.new"
      end

      # gui_background will set the background to the
      # value passed to it through opts.
      # It will accept either a Shoes::Color object or
      # a Shoes::Color object along with some additional
      # options.
      def gui_background(opts)
        if opts.size == 1
          @app.gui_container.setBackground(opts[0].to_native)
          @app.background = opts[0]
        else
          @app.gui_container.addPaintListener(BackgroundPainter.new(opts, @app))
        end
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
        style |= ::Swt::SWT::RESIZE if @app.opts[:resizable]

        style
      end
    end
  end
end


