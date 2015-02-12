class Shoes
  # This is the representation of the app that is used internally by Shoes
  # objects. It is *NOT* the app object that a user interacts with in a
  # Shoes.app block. The user facing App object is...the App object.
  #
  # The InternalApp object is responsible for maintaining the state of the App
  # and providing the bulk of the functionality, leaving the App a relatively
  # blank slate for users to bend to their will.
  class InternalApp
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    extend Forwardable

    DEFAULT_OPTIONS = { width: 600,
                        height: 500,
                        title: "Shoes 4",
                        resizable: true,
                        background: Shoes::COLORS.fetch(:shoes_background) }.freeze

    def initialize(app, opts, &blk)
      @app = app
      @blk = blk
      set_attributes_from_options(opts)
      set_initial_attributes
    end

    def setup_gui
      @gui = Shoes.configuration.backend::App.new self

      self.current_slot = create_top_slot
      execution_blk = create_execution_block(blk)
      eval_block execution_blk

      setup_global_keypresses
      register_console_keypress
    end

    attr_reader :gui, :top_slot, :app, :dimensions,
                :mouse_motion, :owner, :element_styles, :resize_callbacks
    attr_accessor :elements, :current_slot, :opts, :blk, :mouse_button,
                  :mouse_pos, :mouse_hover_controls, :resizable, :app_title,
                  :width, :height, :start_as_fullscreen, :location

    def_delegators :@app, :eval_with_additional_context

    def clear(&blk)
      current_slot.clear(&blk)
    end

    def contents
      top_slot.contents
    end

    def width
      started? ? gui.width : @dimensions.width
    end

    def height
      started? ? gui.height : @dimensions.height
    end

    def font(path = Shoes::DEFAULT_TEXTBLOCK_FONT)
      app.font path
    end

    def started?
      gui && gui.started?
    end

    def add_child(_child)
      # No-op. The top_slot needs this method, but we already hold an explicit
      # reference to the top_slot, so we don't need to add it as a child. Other
      # elements should be added as children of the top_slot.
    end

    def default_styles
      Common::Style::DEFAULT_STYLES.clone
    end

    def in_bounds?(_x, _y)
      true
    end

    def fullscreen=(state)
      gui.fullscreen = state
    end

    def fullscreen
      gui.fullscreen
    end

    alias_method :start_as_fullscreen?, :start_as_fullscreen

    # Necessary for click/mouse positioning checks
    def hidden?
      false
    end

    def add_mouse_hover_control(element)
      return if mouse_hover_controls.include?(element)
      mouse_hover_controls << element
    end

    def open_gui
      gui.open
    end

    def quit
      @gui.quit
    end

    def scroll_top
      gui.scroll_top
    end

    def scroll_top=(n)
      gui.scroll_top = n
    end

    def clipboard
      gui.clipboard
    end

    def clipboard=(str)
      gui.clipboard = str
    end

    def download(url, opts, &block)
      app.download url, opts, &block
    end

    def textcursor(line_height)
      app.line(0, 0, 0, line_height, hidden: true)
    end

    def execute_block(blk)
      app.instance_eval(&blk)
    end

    def gutter
      gui.gutter
    end

    def add_resize_callback(blk)
      @resize_callbacks << blk
    end

    def inspect
      add_detail_to_inspect super, " \"#{@app_title}\" #{@dimensions.inspect}"
    end

    def self.global_keypresses
      @global_keypresses ||= {}
    end

    def self.add_global_keypress(key, &blk)
      global_keypresses[key] = blk
    end

    def wait_until_closed
      return unless gui
      gui.wait_until_closed
    end

    private

    def create_top_slot
      @top_slot = Flow.new self, self, width: width, height: height
    end

    def eval_block(execution_blk)
      @top_slot.append(&execution_blk)
    end

    def create_execution_block(blk)
      if blk
        execution_blk = proc do
          execute_block blk
        end
      elsif Shoes::URL.urls.keys.any? { |page| page.match '/' }
        execution_blk = proc do
          app.visit '/'
        end
      else
        execution_blk = nil
      end
      execution_blk
    end

    def set_initial_attributes
      @style                = default_styles
      @element_styles       = {}
      @mouse_motion         = []
      @mouse_button         = 0
      @mouse_pos            = [0, 0]
      @mouse_hover_controls = []
      @resize_callbacks     = []
      @pass_coordinates     = true
    end

    def set_attributes_from_options(opts)
      opts = DEFAULT_OPTIONS.merge(opts)

      @app_title           = opts[:title]
      @resizable           = opts[:resizable]
      @start_as_fullscreen = opts[:fullscreen]
      @opts                = opts
      @owner               = opts[:owner]
      @dimensions          = AbsoluteDimensions.new opts
      self.absolute_left   = 0
      self.absolute_top    = 0
    end

    def setup_global_keypresses
      @app.keypress do |key|
        blk = self.class.global_keypresses[key]
        @app.instance_eval(&blk) unless blk.nil?
      end
    end

    def register_console_keypress
      self.class.add_global_keypress(:"alt_/") do
        Logger.setup
      end
    end
  end
end
