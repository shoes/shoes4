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
    include Common::Margin
    include BuiltinMethods
    include Common::Clickable

    DEFAULT_OPTIONS = { :width      => 600,
                        :height     => 500,
                        :title      => "Shoes 4",
                        :resizable  => true,
                        :background => Shoes::COLORS[:white] }.freeze

    attr_reader :gui, :top_slot, :contents, :unslotted_elements, :app,
                :mouse_motion, :owner, :location
    attr_accessor :elements, :current_slot, :opts, :blk, :mouse_button,
                  :mouse_pos, :mhcs, :resizable, :app_title
    attr_writer   :width, :height, :start_as_fullscreen

    def initialize(opts={}, &blk)
      set_attributes_from_options(opts)
      set_initial_attributes
      set_margin

      @gui = Shoes.configuration.backend::App.new @app

      execution_blk = create_execution_block(blk)
      eval_block execution_blk

      add_console

      Shoes.register self
      @gui.open
    end

    def window(options={}, &block)
      options.merge! owner: self
      self.class.new(options, &block)
    end

    def width
      started? ? @gui.width : @width
    end

    def height
      started? ? @gui.height : @height
    end

    def left; 0 end
    def top; 0 end
    def absolute_left; 0 end
    def absolute_top; 0 end

    def quit
      Shoes.unregister self
      @gui.quit
    end

    def started?
      @gui && @gui.started
    end

    def clear &blk
      if started?
        super
        @app.unslotted_elements.each &:remove
        @app.unslotted_elements.clear
        @contents << @top_slot
        @current_slot = @top_slot
        instance_eval &blk if blk
        gui.flush
      else
        instance_eval &blk if blk
      end
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

    def rotate angle=nil
      angle ? @rotate = angle : @rotate ||= 0
    end

    def in_bounds?(x, y)
      true
    end

    def to_s
      'Shoes App: ' + app_title
    end

    def fullscreen=(state)
      gui.fullscreen = state
    end

    def fullscreen
      gui.fullscreen
    end

    alias_method :fullscreen?, :fullscreen

    def start_as_fullscreen?
      @start_as_fullscreen
    end

    private
    def eval_block(execution_blk)
      @top_slot = Flow.new self, self, {width: @width, height: @height}, &execution_blk
    end

    def create_execution_block(blk)
      if blk
        execution_blk = Proc.new do
          @app.instance_eval &blk
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
      @app                = self
      @style              = default_styles
      @contents           = []
      @unslotted_elements = []
      @mouse_motion       = []
      @mouse_button       = 0
      @mouse_pos          =[0, 0]
      @mhcs               = []
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
      keypress do |key|
        ::Shoes::Logger.setup if key == :"alt_/"
      end
    end

  end
end
