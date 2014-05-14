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

  # Instantiates a new Shoes app.
  #
  # @param opts [Hash] A hash of options used instantiate the Shoes::App object with.
  # @param blk  [Proc] The block containing the DSL instructions for the actual app.
  #
  # @example
  #   Shoes.app(title: "Chunky") do
  #     para "Bacon is awesome!"
  #   end
  #
  # @return A new instance of Shoes::App
  #
  # @see Shoes::App#initialize

  def self.app(opts={}, &blk)
    Shoes::App.new(opts, &blk)
  end


  # This is the user-facing App object. It is `self` inside of a Shoes.app
  # block, and is the context in which a Shoes app is evaled. It delegates most
  # of its functionality to an InternalApp object, which interacts with other
  # Shoes objects. There should be no unnecessary instance variables or methods
  # in this class, so users are free to use whatever names they choose for
  # their own code.
  class App
    include DSL
    include BuiltinMethods

    # Instantiates a new Shoes app.
    #
    # @param  opts [Hash] The options to initialize the app with.
    # @param  blk  [Proc] The block containing the DSL instructions to be executed within the app.
    #
    # @option opts [String]  :title      ("Shoes 4") The title of the window
    # @option opts [Boolean] :resizable  (true)      Whether the window is resizable
    # @option opts [Boolean] :fullscreen (false)     Whether the app should start in fullscreen
    # @option opts [Fixnum]  :width      (600)       The width of the app window
    # @option opts [Fixnum]  :height     (500)       The height of the app window
    #
    # @see Dimension#initialize
 
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
    
    def parent
      @__app__.current_slot.parent
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

    # inspect normally recursively inspects the values of all instance
    # variables... as the app has a reference to EVERYTHING this turns
    # out to be quite a lot/so much that the app runs out of memory #504
    def inspect
      "#<#{self.class}:0x#{hash.to_s(16)} @__app__=So much stuff literally breaks the memory limit. Look at it selectively.>"
    end

    DELEGATE_BLACKLIST = [:parent]

    # class definitions are evaluated top to bottom, want to have all of them
    # so define at bottom
    DELEGATE_METHODS = ((Shoes::App.public_instance_methods(false) +
      Shoes::DSL.public_instance_methods) - DELEGATE_BLACKLIST).freeze
  end


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

    DEFAULT_OPTIONS = { :width      => 600,
                        :height     => 500,
                        :title      => "Shoes 4",
                        :resizable  => true,
                        :background => Shoes::COLORS.fetch(:shoes_background) }.freeze

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

    attr_reader :gui, :top_slot, :contents, :app, :dimensions,
                :mouse_motion, :owner, :element_styles, :resize_callbacks
    attr_accessor :elements, :current_slot, :opts, :blk, :mouse_button,
                  :mouse_pos, :mouse_hover_controls, :resizable, :app_title,
                  :width, :height, :start_as_fullscreen, :location

    def clear(&blk)
      top_slot.clear &blk
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

    def gutter
      gui.gutter
    end

    def add_resize_callback(blk)
      @resize_callbacks << blk
    end

    private
    def eval_block(execution_blk)
      # creating it first, then appending is important because that way
      # top_slot already exists and methods may be called on it
      @top_slot = Flow.new self, self, width: width, height: height
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
      @resize_callbacks     = []
      @rotate               = 0
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

    def add_console
      console = Proc.new do 
        keypress do |key|
          ::Shoes::Logger.setup if key == :"alt_/"
        end
      end
      @app.instance_eval &console
    end

    def inspect
      "#<#{self.class}:0x#{hash.to_s(16)} @app_title=#{@app_title} @dimensions=#{@dimensions.inspect} and a lot of stuff that's too much too handle... and leads to OutOfMemoryErrors>"
    end

  end
end
