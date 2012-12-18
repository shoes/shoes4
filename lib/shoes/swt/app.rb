require 'swt'

module Shoes
  module Swt
    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #

    class App
      include Common::Container

      def initialize dsl
        @dsl = dsl
        ::Swt::Widgets::Display.app_name = @dsl.app_title
        @background = Color.new(@dsl.opts[:background])
        @real = ::Swt::Widgets::Shell.new(::Swt.display, main_window_style).tap do |shell|
          shell.image = ::Swt::Graphics::Image.new(::Swt.display, SHOES_ICON)
          shell.text = (@dsl.app_title)
          shell.background_mode = ::Swt::SWT::INHERIT_DEFAULT
          shell.background = @background.real
        end
        @shell = @real

        ::Shoes::Swt.register self

        @real = ::Swt::Widgets::Composite.new(@shell, ::Swt::SWT::TRANSPARENT)
        @real.setSize(@dsl.width, @dsl.height)
        @real.setLayout ShoesLayout.new

        @dx = @dy = 0
        @shell.addControlListener ShellControlListener.new(self)
        @shell.addListener(::Swt::SWT::Close, main_window_on_close) if main_app?
        @real.addMouseMoveListener MouseMoveListener.new(self)
        @real.addMouseListener MouseListener.new(self)
        
        vb = @shell.getVerticalBar
        vb.setIncrement 10
        vb.addSelectionListener SelectionListener.new(self, vb)
      end

      attr_reader :dsl, :real, :shell, :dx, :dy

      def open
        @shell.pack
        @shell.open
        @dx, @dy = @shell.getSize.x - @dsl.width, @shell.getSize.y - @dsl.height

        ::Swt.event_loop { ::Shoes::Swt.main_app.disposed? } if main_app?
      end

      def quit
        @shell.dispose
      end

      # @return [Shoes::Swt::App] Self
      def app
        self
      end

      def disposed?
        @shell.disposed?
      end

      def main_app?
        ::Shoes::Swt.main_app.equal? self
      end
      
      def flush
        @dsl.top_slot.contents_alignment @dsl.top_slot
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
        style  = ::Swt::SWT::CLOSE | ::Swt::SWT::MIN | ::Swt::SWT::MAX | ::Swt::SWT::V_SCROLL
        style |= ::Swt::SWT::RESIZE if @dsl.opts[:resizable]
        style
      end
    end

    class ShellControlListener
      def initialize(app)
        @app = app
      end

      def controlResized(e)
        shell = e.widget
        client_area = shell.getClientArea
        w, h = client_area.width, client_area.height
        @app.dsl.top_slot.width, @app.dsl.top_slot.height = w, h
        @app.real.setSize w, h
        @app.real.layout
      end

      def controlMoved(e)
      end
    end

    class MouseMoveListener
      def initialize app
        @app = app
      end
      def mouseMove(e)
        @app.dsl.mouse_pos = [e.x, e.y]
        @app.dsl.mouse_motion.each{|blk| blk[e.x, e.y]}
      end
    end

    class MouseListener
      def initialize app
        @app = app
      end
      def mouseDown(e)
        @app.dsl.mouse_button = e.button
        @app.dsl.mouse_pos = [e.x, e.y]
      end
      def mouseUp(e)
        @app.dsl.mouse_button = 0
        @app.dsl.mouse_pos = [e.x, e.y]
      end
      def mouseDoubleClick(e)
        # do nothing
      end
    end
    
    class SelectionListener
      def initialize app, vb
        @app, @vb = app, vb
      end
      def widgetSelected e
        unless e.detail == ::Swt::SWT::DRAG
          location = @app.real.getLocation
          location.y = -@vb.getSelection
          @app.real.setLocation location
        end
      end
    end
  end
end

