require 'swt'

module Shoes
  module Swt
    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #

    class App
      include Common::Container
      include Common::Clickable

      attr_reader :dsl, :real, :shell, :started
      attr_accessor :ln

      def initialize dsl
        @dsl = dsl
        ::Swt::Widgets::Display.app_name = @dsl.app_title
        @background = Color.new(@dsl.opts[:background])
        initialize_shell()
        initialize_real()
        ::Shoes::Swt.register self

        attach_event_listeners

        vb = @shell.vertical_bar
        vb.increment = 10
        vb.add_selection_listener SelectionListener.new(self, vb)
      end

      def open
        @shell.pack
        @shell.open
        @started = true
        ::Swt.event_loop { ::Shoes::Swt.main_app.disposed? } if main_app?
      end

      def quit
        @shell.dispose
      end

      # @return [Shoes::Swt::App] Self
      def app
        self
      end

      def width
        if @shell.vertical_bar.visible 
          @shell.client_area.width + @shell.vertical_bar.size.x
        else
          @shell.client_area.width
        end
      end

      def height
        @shell.client_area.height
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

      def scroll_top
        @real.location.y
      end
      
      def scroll_top=(n)
        @real.setLocation(0, -n)
        @shell.vertical_bar.selection = n
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

      def initialize_shell
        @shell = ::Swt::Widgets::Shell.new(::Swt.display, main_window_style)
        @shell.image = ::Swt::Graphics::Image.new(::Swt.display, SHOES_ICON)
        @shell.text = (@dsl.app_title)
        @shell.background_mode = ::Swt::SWT::INHERIT_DEFAULT
        @shell.background = @background.real
      end

      def initialize_real
        @real = ::Swt::Widgets::Composite.new(@shell, ::Swt::SWT::TRANSPARENT)
        @real.setSize(@dsl.width - @shell.getVerticalBar.getSize.x, @dsl.height)
        @real.layout = ShoesLayout.new
      end

      def attach_event_listeners
        attach_shell_event_listeners
        attach_real_event_listeners
      end

      def attach_shell_event_listeners
        @shell.add_control_listener ShellControlListener.new(self)
        @shell.add_listener(::Swt::SWT::Close, main_window_on_close) if main_app?
      end

      def attach_real_event_listeners
        @real.add_mouse_move_listener MouseMoveListener.new(self)
        @real.add_mouse_listener MouseListener.new(self)
      end

    end

    class ShellControlListener
      def initialize(app)
        @app = app
      end

      def controlResized(event)
        shell = event.widget
        width = shell.client_area().width
        height = shell.client_area().height
        @app.dsl.top_slot.width  = width
        @app.dsl.top_slot.height = height
        @app.real.setSize width, height
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
        if @app.shell.vertical_bar.visible and e.detail != ::Swt::SWT::DRAG
          location = @app.real.location
          location.y = -@vb.selection
          @app.real.location = location
        end
      end
    end

  end
end

