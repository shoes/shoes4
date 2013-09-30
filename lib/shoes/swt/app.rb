class Shoes
  module Swt
    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #

    class App
      include Common::Container
      include Common::Clickable

      attr_reader :dsl, :real, :shell, :started, :clickable_elements

      def initialize dsl
        @clickable_elements = []
        @dsl = dsl
        ::Swt::Widgets::Display.app_name = @dsl.app_title
        @background = Color.new(@dsl.opts[:background])
        initialize_shell
        initialize_real
        ::Shoes::Swt.register self
        attach_event_listeners
        initialize_scroll_bar
        @redrawing_aspect = RedrawingAspect.new self, Shoes.display
      end

      def open
        @shell.pack
        force_shell_size
        @shell.open
        @dsl.top_slot.contents_alignment
        @started = true
        self.fullscreen = true if dsl.start_as_fullscreen?
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
        if @dsl.top_slot
          @dsl.top_slot.contents_alignment
          @real.layout
        end
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
        ::Swt::Clipboard.new(Shoes.display).setContents(
          [str].to_java,
          [::Swt::TextTransfer.getInstance].to_java(::Swt::TextTransfer)
        )
      end

      def fullscreen=(state)
        @shell.full_screen = state
      end

      def fullscreen
        @shell.full_screen
      end

      def add_clickable_element(element)
        @clickable_elements << element
      end

      private
      def initialize_scroll_bar
        scroll_bar = @shell.getVerticalBar
        scroll_bar.setIncrement 10
        selection_listener = SelectionListener.new(scroll_bar) do |vertical_bar, event|
          if self.shell.getVerticalBar.getVisible and event.detail != ::Swt::SWT::DRAG
            vertically_scroll_window(vertical_bar)
          end
        end
        scroll_bar.addSelectionListener selection_listener
      end

      def vertically_scroll_window(vertical_bar)
          location = self.real.getLocation
          location.y = -vertical_bar.getSelection
          self.real.setLocation location
      end

      def force_shell_size
        frame_x_decorations = @shell.getSize().x - @shell.getClientArea().width
        frame_y_decorations = @shell.getSize().y - @shell.getClientArea().height
        new_width = @dsl.width + frame_x_decorations
        new_height = @dsl.height + frame_y_decorations
        @shell.setSize(new_width, new_height)
      end

      def main_window_on_close
        lambda { |event|
          ::Swt.display.dispose
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
        @real = ::Swt::Widgets::Composite.new(@shell, 
          ::Swt::SWT::TRANSPARENT | ::Swt::SWT::NO_RADIO_GROUP)
        @real.setSize(@dsl.width - @shell.getVerticalBar.getSize.x, @dsl.height)
        @real.setLayout init_shoes_layout
      end

      # it seems like the class can not not have a constructor with an argument
      # due to its java super class
      def init_shoes_layout
        layout         = ShoesLayout.new
        layout.gui_app = self
        layout
      end

      def attach_event_listeners
        attach_shell_event_listeners
        attach_real_event_listeners
      end

      def attach_shell_event_listeners
        @shell.addControlListener ShellControlListener.new(self)
        @shell.addListener(::Swt::SWT::Close, main_window_on_close) if main_app?
        @shell.addListener(::Swt::SWT::Close, unregister_app)
      end

      def unregister_app
        proc do |event|
          ::Shoes::Swt.unregister(self)
        end
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
        cursor = if cursor_over_clickable_element?
                   ::Swt::SWT::CURSOR_HAND
                 else
                   ::Swt::SWT::CURSOR_ARROW
                 end
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
  
      def mouse_on? element
        mb, mx, my = element.app.mouse
        element.in_bounds? mx, my
      end

      private
      def cursor_over_clickable_element?
        mouse_x, mouse_y = @app.dsl.mouse_pos
        @app.clickable_elements.any? do |element|
          element.in_bounds? mouse_x, mouse_y
        end
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

  end
end

