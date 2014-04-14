class Shoes
  module Swt
    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #

    class App
      include Common::Container
      include Common::Clickable

      attr_reader :dsl, :real, :shell, :clickable_elements

      def initialize dsl
        @clickable_elements = []
        @dsl = dsl
        ::Swt::Widgets::Display.app_name = @dsl.app_title
        @background = Color.new(@dsl.opts[:background])
        @started = false
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
        flush
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
        if overlay_scrollbars?
          @shell.client_area.width
        else
          width_adjusted_for_scrollbars
        end
      end

      def height
        @shell.client_area.height
      end

      def disposed?
        @shell.disposed? || @real.disposed?
      end

      def redraw(left=nil, top=nil, width=nil, height=nil, all=true)
        unless @real.disposed?
          if (left == nil or top == nil or width == nil or height == nil)
            @real.redraw
          else
            @real.redraw(left, top, width, height, all)
          end
        end
      end

      def main_app?
        ::Shoes::Swt.main_app.equal? self
      end

      def flush
        if @dsl.top_slot
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

      def started?
        @started
      end

      # This represents the space (potentially) occupied by a vertical
      # scrollbar. Since the scrollbar may not be visible at the time this
      # method is called, we don't rely on its reported value.
      def gutter
        # 16
        @shell.getVerticalBar.getSize.x
      end

      def add_key_listener(listener)
        @key_listeners[listener.class] << listener
      end

      def remove_key_listener(listener)
        @key_listeners[listener.class].delete(listener)
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
        frame_x_decorations = @shell.size.x - @shell.client_area.width
        frame_y_decorations = @shell.size.y - @shell.client_area.height
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
        attach_key_event_listeners
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

      def attach_key_event_listeners
        @key_listeners = {
          Keypress   => [],
          Keyrelease => [],
        }
        attach_key_event_listener(::Swt::SWT::KeyDown, Keypress)
        attach_key_event_listener(::Swt::SWT::KeyUp,   Keyrelease)
      end

      def attach_key_event_listener(listen_for, listener_class)
        ::Swt.display.add_filter(listen_for) do |evt|
          @key_listeners[listener_class].each do |listener|
            listener.handle_key_event(evt)
          end
        end
      end

      def overlay_scrollbars?
        @shell.scrollbars_mode == ::Swt::SWT::SCROLLBAR_OVERLAY
      end

      def width_adjusted_for_scrollbars
        if @shell.getVerticalBar.getVisible
          @shell.client_area.width + @shell.getVerticalBar.getSize.x
        else
          @shell.client_area.width
        end
      end

    end

    class ShellControlListener
      def initialize(app)
        @app = app
      end

      def controlResized(event)
        shell = event.widget
        width = shell.client_area.width
        height = shell.client_area.height
        @app.dsl.top_slot.width   = width
        @app.dsl.top_slot.height  = height
        @app.real.setSize width, height
        @app.real.layout
        @app.dsl.resize_callbacks.each{|blk| blk.call}
      end

      def controlMoved(e)
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

