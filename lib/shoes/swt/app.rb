require 'swt'
require 'shoes/swt/background_painter'

module Shoes
  module Swt

    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #
    module App

      def gui_init
        self.gui_container = container = 
          ::Swt::Widgets::Shell.new(::Swt.display, main_window_style)
        layout = ::Swt::Layout::RowLayout.new
        container.setLayout(layout)

        opts = self.opts

        container.setBackground(background.to_native)
        container.setSize(self.width, self.height)
        container.setText(self.title)

        container.addListener(::Swt::SWT::Close, main_window_on_close)
      end

      def gui_open
        self.gui_container.open
        ::Swt.event_loop { ::Swt.display.isDisposed }

        Shoes.logger.debug "::Swt.display disposed... exiting Shoes::App.new"
      end

      private
      # gui_background will set the background to the
      # value passed to it through opts.
      # It will accept either a Shoes::Color object or
      # a Shoes::Color object along with some additional
      # options.
      def gui_background(opts)
        if opts.size == 1
          self.gui_container.setBackground(opts[0].to_native)
          @background = opts[0]
        else
          self.gui_container.addPaintListener(BackgroundPainter.new(opts, self))
        end
      end

      def main_window_on_close
        lambda {
          Shoes.logger.debug "main_window on_close block begin... disposing ::Swt.display"
          ::Swt.display.dispose
          Shoes.logger.debug "::Swt.display disposed"
        }
      end

      def main_window_style
        style  = ::Swt::SWT::CLOSE
        style |= ::Swt::SWT::RESIZE if opts[:resizable]

        style
      end
    end
  end
end

module Shoes
  class App
    include Shoes::Swt::App
  end
end

