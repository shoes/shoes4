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
          shell.set_image ::Swt::Graphics::Image.new(::Swt.display, SHOES_ICON)
          shell.setText(@dsl.app_title)
          shell.addListener(::Swt::SWT::Close, main_window_on_close)
          shell.background_mode = ::Swt::SWT::INHERIT_DEFAULT
        end
        background Array(@dsl.background)
        @shell = @real
        @real = ::Swt::Widgets::Composite.new(@shell, ::Swt::SWT::INHERIT_DEFAULT)
        @real.setSize(@dsl.width, @dsl.height)
        @real.setLayout ::Swt::Layout::RowLayout.new

        @dx = @dy = 0
        s = self
        cl = ::Swt::ControlListener.new
        class << cl; self end.
        instance_eval do
          define_method(:controlResized){|e| s.real.setSize s.shell.getSize.x - s.dx, s.shell.getSize.y - s.dy}
          define_method(:controlMoved){|e|}
        end
        @shell.addControlListener cl
      end

      attr_reader :background
      attr_reader :real, :shell, :dx, :dy

      def open
        @shell.pack
        @shell.open
        @dx, @dy = @shell.getSize.x - @dsl.width, @shell.getSize.y - @dsl.height

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


