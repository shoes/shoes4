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
      attr_accessor :ln, :mscs

      def initialize dsl
        @mscs = []
        @dsl = dsl
        ::Swt::Widgets::Display.app_name = @dsl.app_title
        @background = Color.new(@dsl.opts[:background])
        initialize_shell()
        initialize_real()
        ::Shoes::Swt.register self

        attach_event_listeners

        vb = @shell.getVerticalBar
        vb.setIncrement 10
        vb.addSelectionListener SelectionListener.new(self, vb)
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
        @shell.getVerticalBar.getVisible ? (@shell.client_area.width + @shell.getVerticalBar.getSize.x) : @shell.client_area.width
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
        @real.layout
      end

      def scroll_top
        @real.getLocation.y
      end
      
      def scroll_top=(n)
        @real.setLocation 0, -n
        @shell.getVerticalBar.setSelection n
      end

      def clipboard
        ::Swt::Clipboard.new(Shoes.display).getContents ::Swt::TextTransfer.getInstance
      end

      def clipboard=(str)
#        ::Swt::Toolkit.getDefaultToolkit.getSystemClipboard.setContents ::Swt::StringSelection.new(str), Shoes
      end

      private
      def main_window_on_close
        lambda { |event|
          Shoes.logger.debug "main_window on_close block begin... disposing ::Swt.display"
          ::Swt.display.dispose
          Shoes.logger.debug "::Swt.display disposed"
          Dir[File.join(Dir.tmpdir, "__shoes4_*.png")].each{|f| File.delete f}
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
        @real.setLayout ShoesLayout.new
      end

      def attach_event_listeners
        attach_shell_event_listeners
        attach_real_event_listeners
      end

      def attach_shell_event_listeners
        @shell.addControlListener ShellControlListener.new(self)
        @shell.addListener(::Swt::SWT::Close, main_window_on_close) if main_app?
      end

      def attach_real_event_listeners
        @real.addMouseMoveListener MouseMoveListener.new(self)
        @real.addMouseListener MouseListener.new(self)
      end

    end

    class ShellControlListener
      def initialize(app)
        @app = app
      end

      def controlResized(event)
        shell = event.widget
        width = shell.getClientArea().width
        height = shell.getClientArea().height
        @app.dsl.top_slot.width   = width
        @app.dsl.top_slot.height  = height
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
        mouse_shape_control
        mouse_hover_control
        mouse_leave_control
      end
      def mouse_shape_control
        flag = false
        mouse_x, mouse_y = @app.dsl.mouse_pos
        @app.mscs.each do |s|
          if s.is_a?(::Shoes::Link) and !s.parent.hidden
            flag = true if ((s.pl..(s.pl+s.pw)).include?(mouse_x) and (s.sy..s.ey).include?(mouse_y) and !((s.pl..s.sx).include?(mouse_x) and (s.sy..(s.sy+s.lh)).include?(mouse_y)) and !((s.ex..(s.pl+s.pw)).include?(mouse_x) and ((s.ey-s.lh)..s.ey).include?(mouse_y)))
          elsif !s.is_a?(::Shoes::Link) and !s.hidden
            dx, dy = s.is_a?(Star) ? [s.width / 2.0, s.height / 2.0] : [0, 0]
            flag = true if s.left - dx <= mouse_x and mouse_x <= s.left - dx + s.width and s.top - dy <= mouse_y and mouse_y <= s.top - dy + s.height
          end
        end
        cursor = flag ? ::Swt::SWT::CURSOR_HAND : ::Swt::SWT::CURSOR_ARROW
        @app.shell.setCursor  Shoes.display.getSystemCursor(cursor)
      end

      def mouse_hover_control
        @app.dsl.mhcs.each do |e|
          if mouse_on?(e) and !e.hovered
            e.hovered = true
            e.hover_proc[e] if e.hover_proc
          end
        end
      end

      def mouse_leave_control
        @app.dsl.mhcs.each do |e|
          if !mouse_on?(e) and e.hovered
            e.hovered = false
            e.leave_proc[e] if e.leave_proc
          end
        end
      end
  
      def mouse_on? e
        mb, mx, my = e.app.mouse
        dx, dy = e.is_a?(Star) ? [e.width / 2.0, e.height / 2.0] : [0, 0]
        e.left - dx <= mx and mx <= e.left - dx + e.width and e.top - dy <= my and my <= e.top - dy + e.height
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
        if @app.shell.getVerticalBar.getVisible and e.detail != ::Swt::SWT::DRAG
          location = @app.real.getLocation
          location.y = -@vb.getSelection
          @app.real.setLocation location
        end
      end
    end

  end
end

