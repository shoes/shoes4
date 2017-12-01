# frozen_string_literal: true

class Shoes
  module Swt
    shoes_icon = ::Shoes::ICON
    if shoes_icon.include? 'uri:classloader'
      ICON = File.join(Dir.tmpdir, 'shoes-icon.png').freeze
      open ICON, 'wb' do |fw|
        open shoes_icon, 'rb' do |fr|
          fw.write fr.read
        end
      end
    else
      ICON = shoes_icon
    end

    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #
    class App
      include Common::Container
      include Common::Clickable

      attr_reader :dsl, :real, :shell, :click_listener

      def initialize(dsl)
        if self.class.main_app_closed?
          Shoes.logger.error <<~EOS
            Sorry! You can't start another Shoes.app at after the main one has already
            finished like that! If you need multiple windows, try it more like this:

                Shoes.app do
                  para "first!"
                  Shoes.app do
                    para "second!"
                  end
                end
EOS
          exit 1
        end

        @dsl = dsl

        ::Swt::Widgets::Display.app_name = @dsl.app_title

        ::Shoes::Swt::App.setup_system_colors
        ::Shoes::Swt::Font.setup_fonts

        @background = Color.new(@dsl.opts[:background] ||
                               ::Shoes::COLORS.fetch(:system_background))
        @started = false
        initialize_shell
        initialize_real
        ::Shoes::Swt.register self
        attach_event_listeners
        initialize_scroll_bar

        @redrawing_aspect = RedrawingAspect.new self, Shoes.display
      end

      def open
        # If something called quit during the app block's initial evaluation
        # we might already be disposed of, in which case get out of here!
        return if ::Shoes::Swt.main_app.disposed? || @shell.disposed?

        @shell.pack
        force_shell_size
        @shell.open
        @started = true
        self.fullscreen = true if dsl.start_as_fullscreen?
        flush
        ::Swt.event_loop { ::Shoes::Swt.apps.all?(&:disposed?) } if main_app?
      end

      def quit
        @image.dispose
        @background.dispose
        @shell.dispose
      end

      # @return [Shoes::Swt::App] Self
      def app
        self
      end

      def width
        shell.client_area.width
      end

      def height
        shell.client_area.height
      end

      def open?
        !disposed?
      end

      def disposed?
        @shell.disposed? || @real.disposed?
      end

      def focus
        @shell.force_active
      end

      def redraw(left = nil, top = nil, width = nil, height = nil, all = true)
        return if @real.disposed?

        if left.nil? || top.nil? || width.nil? || height.nil?
          @real.redraw
        else
          @real.redraw(left, top, width, height, all)
        end
      end

      def main_app?
        ::Shoes::Swt.main_app.equal? self
      end

      def flush
        @real.layout if @dsl.top_slot
      end

      def scroll_top
        @real.location.y
      end

      def scroll_top=(n)
        @real.setLocation 0, -n
        @shell.vertical_bar.selection = n
      end

      # Java doesn't like ruby-style accessors here for some reason
      def clipboard
        ::Swt::Clipboard.new(Shoes.display).getContents ::Swt::TextTransfer.getInstance
      end

      def clipboard=(str)
        ::Swt::Clipboard.new(Shoes.display).setContents(
          [str].to_java,
          [::Swt::TextTransfer.getInstance].to_java(::Swt::TextTransfer),
          ::Swt::DND::DND::CLIPBOARD
        )
      end

      def fullscreen=(state)
        @shell.full_screen = state
      end

      def fullscreen
        @shell.full_screen
      end

      def clickable_elements
        @click_listener.clickable_elements
      end

      def started?
        @started
      end

      # This represents the space (potentially) occupied by a vertical
      # scrollbar. Since the scrollbar may not be visible at the time this
      # method is called, we don't rely on its reported value.
      def gutter
        # 16
        @shell.vertical_bar.size.x
      end

      def add_key_listener(listener)
        @key_listeners[listener.class] << listener
      end

      def remove_key_listener(listener)
        @key_listeners[listener.class].delete(listener)
      end

      # For use from modal Shoes windows, keeps pumping UI messages but hangs
      # on from executing other Shoes code until we're done.
      def wait_until_closed
        until @shell.isDisposed
          ::Swt.display.sleep unless ::Swt.display.readAndDispatch
        end
      end

      def self.setup_system_colors
        # Skip it if we've already loaded the color!
        return if ::Shoes::COLORS[:system_background]

        # just one color for now
        background_color = Shoes.display.getSystemColor(::Swt::SWT::COLOR_WIDGET_BACKGROUND)
        ::Shoes::DSL.define_shoes_color(:system_background,
                                        background_color.red,
                                        background_color.green,
                                        background_color.blue)
      end

      # Because SWT shutdown is hard to reverse, we only let you do it once
      # and warn you if you try to run again afterward.
      def self.main_app_closed?
        @main_app_closed ||= false
      end

      def self.mark_main_app_closed
        @main_app_closed = true
      end

      private

      def initialize_scroll_bar
        scroll_bar = @shell.vertical_bar
        scroll_bar.increment = 10
        selection_listener = SelectionListener.new(scroll_bar) do |vertical_bar, event|
          if shell.vertical_bar.visible && event.detail != ::Swt::SWT::DRAG
            vertically_scroll_window(vertical_bar)
          end
        end
        scroll_bar.addSelectionListener selection_listener
      end

      def vertically_scroll_window(vertical_bar)
        location = real.location
        location.y = -vertical_bar.selection
        real.location = location
      end

      def force_shell_size
        frame_x_decorations = @shell.size.x - @shell.client_area.width
        frame_y_decorations = @shell.size.y - @shell.client_area.height
        new_width = @dsl.width + frame_x_decorations
        new_height = @dsl.height + frame_y_decorations
        @shell.setSize(new_width, new_height)
      end

      def on_close
        lambda do |_event|
          # Only do final cleanup if this is the last open window around
          if finished?
            ::Swt.display.dispose
            ::Shoes::Swt::App.mark_main_app_closed
            Dir[File.join(Dir.tmpdir, "__shoes4_*.png")].each { |f| File.delete f }
          end
        end
      end

      def finished?
        # When closing we're done if we're the last undisposed window around
        ::Shoes::Swt.apps.reject(&:disposed?) == [self]
      end

      def main_window_style
        style  = ::Swt::SWT::CLOSE | ::Swt::SWT::MIN | ::Swt::SWT::V_SCROLL
        style |= ::Swt::SWT::RESIZE | ::Swt::SWT::MAX if @dsl.opts[:resizable]
        style |= ::Swt::SWT::APPLICATION_MODAL        if @dsl.opts[:modal]
        style |= ::Swt::SWT::ON_TOP                   if @dsl.opts[:always_on_top]
        style |= ::Swt::SWT::NO_TRIM                  unless @dsl.opts.fetch(:border, true)
        style
      end

      def initialize_shell
        @image = ::Swt::Graphics::Image.new(::Swt.display, ICON)

        @shell = ::Swt::Widgets::Shell.new(::Swt.display, main_window_style)
        @shell.image = @image
        @shell.text = @dsl.app_title
        @shell.background_mode = ::Swt::SWT::INHERIT_DEFAULT
        @shell.background = @background.real
      end

      def initialize_real
        @real = ::Swt::Widgets::Composite.new(@shell,
                                              ::Swt::SWT::TRANSPARENT | ::Swt::SWT::NO_RADIO_GROUP)
        @real.setSize(@dsl.width - @shell.vertical_bar.size.x, @dsl.height)
        @real.layout = init_shoes_layout
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
        attach_click_listener
      end

      def attach_shell_event_listeners
        @shell.addControlListener ShellControlListener.new(self)
        @shell.addListener(::Swt::SWT::Close, on_close)
        @shell.addListener(::Swt::SWT::Close, unregister_app)
      end

      def unregister_app
        proc do |_event|
          ::Shoes::Swt.unregister(self)
          ::Shoes.unregister(dsl.app)
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
          if for_this_shell?(evt)
            @key_listeners[listener_class].each do |listener|
              break if listener.ignore_event?(evt)
              listener.handle_key_event(evt)
            end
          end
        end
      end

      def attach_click_listener
        @click_listener = ClickListener.new(self)
      end

      def for_this_shell?(evt)
        evt.widget.shell == @shell unless evt.widget.disposed?
      end
    end

    class ShellControlListener
      def initialize(app)
        @app = app
      end

      def controlResized(event)
        shell = event.widget
        width  = shell.client_area.width
        height = shell.client_area.height
        @app.real.setSize width, height
        @app.real.layout
        @app.dsl.trigger_resize_callbacks
      end

      def controlMoved(_e)
      end
    end

    class MouseListener
      def initialize(app)
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

      def mouseDoubleClick(_e)
        # do nothing
      end
    end
  end
end
