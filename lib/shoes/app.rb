class Shoes
  shoes_icon = File.expand_path("../../../static/shoes-icon.png", __FILE__)
  if shoes_icon.include? '.jar!'
    SHOES_ICON = File.join(Dir.tmpdir, 'shoes-icon.png').freeze
    open SHOES_ICON, 'wb' do |fw|
      open shoes_icon, 'rb' do |fr|
        fw.write fr.read
      end
    end
  else
    SHOES_ICON = shoes_icon.freeze
  end

  def self.app(opts={}, &blk)
    Shoes::App.new(opts, &blk)
  end

  class App
    include DSL
    include BuiltinMethods

    def initialize(opts={}, &blk)
      @__app__ = Shoes::InternalApp.new(self, opts, &blk)
      @__app__.setup_gui
      Shoes.register self
      @__app__.open_gui
    end

    # Shoes 3 exposes the app object like this, so we keep it for
    # compatibility
    def app
      self
    end

    # FIXME placeholder for code that calls app.gui. We should be able to get
    # rid of this
    def gui
      @__app__.gui
    end

    def window(options={}, &block)
      options.merge! owner: self
      self.class.new(options, &block)
    end

    def close
      quit
    end

    def quit
      Shoes.unregister self
      @__app__.quit
    end

    def to_s
      'Shoes App: ' + @__app__.app_title
    end

    %w(
      width height owner started? location left top absolute_left
      absolute_top rotate click release clear fullscreen fullscreen=
      contents
    ).each do |method|
      define_method method do |*args, &block|
        @__app__.public_send method, *args, &block
      end
    end

    alias_method :fullscreen?, :fullscreen
  end

  class InternalApp
    include Common::Style
    include Common::Clickable

    DEFAULT_OPTIONS = { :width      => 600,
                        :height     => 500,
                        :title      => "Shoes 4",
                        :resizable  => true,
                        :background => Shoes::COLORS[:white] }.freeze

    def initialize(app, opts, &blk)
      @app = app
      @blk = blk
      set_attributes_from_options(opts)
      set_initial_attributes
    end

    def setup_gui
      @gui = Shoes.configuration.backend::App.new self

      execution_blk = create_execution_block(blk)
      eval_block execution_blk

      add_console
    end

    attr_reader :gui, :top_slot, :contents, :app,
                :mouse_motion, :owner, :element_styles
    attr_accessor :elements, :current_slot, :opts, :blk, :mouse_button,
                  :mouse_pos, :mouse_hover_controls, :resizable, :app_title,
                  :width, :height, :start_as_fullscreen, :location

    def clear(&blk)
      top_slot.clear &blk
    end

    def width
      started? ? gui.width : @width
    end

    def height
      started? ? gui.height : @height
    end

    def font(path = Shoes::DEFAULT_TEXTBLOCK_FONT) 
      app.font path
    end

    def started?
      gui && gui.started?
    end

    def rotate angle=nil
      @rotate = angle || @rotate || 0
    end

    def add_child(child)
      if top_slot
        top_slot.add_child child
      else
        contents << child
      end
    end

    def default_styles
      {
        :stroke      => Shoes::COLORS[:black],
        :strokewidth => 1
      }
    end

    def in_bounds?(x, y)
      true
    end

    def fullscreen=(state)
      gui.fullscreen = state
    end

    def fullscreen
      gui.fullscreen
    end

    alias_method :start_as_fullscreen?, :start_as_fullscreen

    def add_mouse_hover_control(element)
      unless mouse_hover_controls.include? element
        mouse_hover_controls << element
      end
    end

    def open_gui
      gui.open
    end

    def quit
      @gui.quit
    end

    def left; 0 end
    def top; 0 end
    def absolute_left; 0 end
    def absolute_top; 0 end

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
      app.line(0, 0, 0, line_height, hidden: true, strokewidth: 1, stroke: ::Shoes::COLORS[:black])
    end

    def execute_block(blk)
      app.instance_eval &blk
    end

    private
    def eval_block(execution_blk)
      # creating it first, then appending is important because that way
      # top_slot already exists and methods may be called on it
      @top_slot = Flow.new self, self, width: @width, height: @height
      @top_slot.append &execution_blk
    end

    def create_execution_block(blk)
      if blk
        execution_blk = Proc.new do
          execute_block blk
        end
      elsif Shoes::URL.urls.keys.any? { |page| page.match '/' }
        execution_blk = Proc.new do
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
      @contents             = []
      @mouse_motion         = []
      @mouse_button         = 0
      @mouse_pos            = [0, 0]
      @mouse_hover_controls = []
      @rotate               = 0
    end

    def set_attributes_from_options(opts)
      opts = DEFAULT_OPTIONS.merge(opts)

      self.width               = opts[:width]
      self.height              = opts[:height]
      self.app_title           = opts[:title]
      self.resizable           = opts[:resizable]
      self.opts                = opts
      self.start_as_fullscreen = opts[:fullscreen]

      @owner = opts[:owner]
    end

    def add_console
      console = Proc.new do 
        keypress do |key|
          ::Shoes::Logger.setup if key == :"alt_/"
        end
      end
      @app.instance_eval &console
    end

  end
end
