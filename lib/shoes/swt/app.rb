require 'swt'

#require 'shoes/framework_adapters/swt_shoes/window'

module Shoes
  module Swt

    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #
    class App

      def initialize app
        @app = app
        @app.gui_container = container = ::Swt::Widgets::Shell.new(::Swt.display, main_window_style)
        layout = ::Swt::Layout::RowLayout.new
        container.setLayout(layout)

        container.setSize(app.width, app.height)
        container.setText(app.title)

        container.addListener(::Swt::SWT::Close, main_window_on_close)
      end


      def open
        @app.gui_container.open

        ::Swt.event_loop { ::Swt.display.isDisposed }

        Shoes.logger.debug "::Swt.display disposed... exiting Shoes::App.new"
      end

      private
      def main_window_on_close
        lambda {
          Shoes.logger.debug "main_window on_close block begin... disposing ::Swt.display"
          ::Swt.display.dispose
          Shoes.logger.debug "::Swt.display disposed"
        }
      end

      def main_window_style
        style  = ::Swt::SWT::CLOSE
        style |= ::Swt::SWT::RESIZE if @app.opts[:resizable]

        style
      end
    end
  end
end


