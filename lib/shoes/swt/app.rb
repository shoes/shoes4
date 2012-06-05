require 'swt'

#require 'shoes/framework_adapters/swt_shoes/window'

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

      def background(*opts)
        return @background if opts.empty?
        if opts.size == 1
          puts "only one argument"
          self.gui_container.setBackground(opts[0].to_native)
          @background = opts[0]
        else
          self.gui_container.addPaintListener(BackgroundPainter.new(opts, self))
        end
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
        style |= ::Swt::SWT::RESIZE if opts[:resizable]

        style
      end

      # BackgroundPainter is the thing that paints and repaints the background.
      # It is only used if the user supplies any parameters other than the color.
      class BackgroundPainter
        include org.eclipse.swt.events.PaintListener
        attr_accessor :options, :color

        def initialize(*opts, app)
          @app = app
          self.options = opts[0][1]         
          self.color   = opts[0][0]
        end

        def paintControl(e)
          x        = 0 
          y        = 0
          width  = e.width
          height = e.height

          width  = options[:width]  if options.has_key? :width
          height = options[:height] if options.has_key? :height

          # top
          if options.has_key? :top
            y = options[:top]
            height -= options[:top]
          end

          # bottom
          if options.has_key? :bottom
            height -= options[:bottom]
          end

          # left
          if options.has_key? :left
            x += options[:left]
            width -= options[:left]
          end

          # right
          if options.has_key? :right
            width -= options[:right]
          end

          e.gc.setBackground(self.color.to_native) 
          e.gc.fillRectangle(x, y, width, height)
        end
      end
    end
  end
end

module Shoes
  class App
    include Shoes::Swt::App
  end
end

