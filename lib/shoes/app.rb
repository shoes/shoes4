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
    include Common::Clickable

    def initialize(opts={}, &blk)
      @__private_proxy__ = Shoes::AppProxy.new(self, opts, &blk)
      @__private_proxy__.setup_gui
      Shoes.register self
      @__private_proxy__.open_gui
    end

    # FIXME placeholder for code that calls app.gui. We should be able to get
    # rid of this
    def gui
      @__private_proxy__.gui
    end

    def window(options={}, &block)
      options.merge! owner: self
      self.class.new(options, &block)
    end

    def left; 0 end
    def top; 0 end
    def absolute_left; 0 end
    def absolute_top; 0 end

    def quit
      Shoes.unregister self
      @__private_proxy__.gui.quit
    end

    def clear &blk
      @__private_proxy__.clear &blk
    end

    def rotate angle=nil
      angle ? @__private_proxy__.rotate = angle : @__private_proxy__.rotate ||= 0
    end

    def to_s
      'Shoes App: ' + @__private_proxy__.app_title
    end

    def fullscreen=(state)
      gui.fullscreen = state
    end

    def fullscreen
      gui.fullscreen
    end

    alias_method :fullscreen?, :fullscreen

    def close
      quit
    end
  end

  class AppProxy
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

    attr_reader :gui, :top_slot, :contents, :unslotted_elements, :app,
                :mouse_motion, :owner, :location, :style, :element_styles
    attr_accessor :elements, :current_slot, :opts, :blk, :mouse_button,
                  :mouse_pos, :mouse_hover_controls, :resizable, :app_title
    attr_writer   :width, :height, :start_as_fullscreen

    def clear &blk
      if started?
        super
        @unslotted_elements.each &:remove
        @unslotted_elements.clear
        @contents << @top_slot
        @current_slot = @top_slot
        @app.instance_eval &blk if blk
        gui.flush
      else
        @app.instance_eval &blk if blk
      end
    end

    def width
      started? ? @gui.width : @width
    end

    def height
      started? ? @gui.height : @height
    end

    def font(path = Shoes::DEFAULT_TEXTBLOCK_FONT) 
      @app.font path
    end

    def started?
      @gui && @gui.started
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

    def start_as_fullscreen?
      @start_as_fullscreen
    end

    def add_mouse_hover_control(element)
      unless mouse_hover_controls.include? element
        mouse_hover_controls << element
      end
    end

    def open_gui
      @gui.open
    end

    private
    def eval_block(execution_blk)
      @top_slot = Flow.new self, self, {width: @width, height: @height}, &execution_blk
    end

    def execute_block(blk)
      @app.instance_eval &blk
    end

    def create_execution_block(blk)
      if blk
        execution_blk = Proc.new do
          execute_block blk
        end
      elsif Shoes::URL.urls.keys.any? { |page| page.match '/' }
        execution_blk = Proc.new do
          visit '/'
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
