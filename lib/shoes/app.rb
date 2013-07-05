require 'shoes/dsl'
require 'shoes/color'
require 'shoes/common/margin'
require 'tmpdir'
require 'fileutils'

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
    include Shoes::DSL
    include Shoes::Common::Margin
    include Shoes::BuiltinMethods
    include Shoes::Common::Clickable

    DEFAULT_OPTIONS = { :width      => 600,
                        :height     => 500,
                        :title      => "Shoes 4",
                        :resizable  => true,
                        :background => Shoes::COLORS[:white] }.freeze

    attr_reader :gui, :shell, :top_slot, :contents, :unslotted_elements, :location
    attr_reader :app, :mouse_motion, :owner, :hidden
    attr_accessor :elements, :current_slot
    attr_accessor :opts, :blk
    attr_accessor :mouse_button, :mouse_pos, :mhcs

    attr_accessor :resizable, :app_title
    attr_writer   :width, :height

    def initialize(opts={}, &blk)
      opts = DEFAULT_OPTIONS.merge(opts)

      self.width      = opts[:width]
      self.height     = opts[:height]
      self.app_title  = opts[:title]
      self.resizable  = opts[:resizable]
      self.opts       = opts

      @owner = opts[:owner]
      @app = self
      @style = default_styles
      @contents, @unslotted_elements = [], []
      @mouse_motion = []
      @mouse_button, @mouse_pos = 0, [0, 0]
      @mhcs = []
      set_margin

      @gui = Shoes.configuration.backend::App.new @app

      if blk
        execution_blk = Proc.new do @app.instance_eval &blk end
      else
        execution_blk = Proc.new do visit '/' end
      end

      @top_slot = Flow.new self, self, { left: 0, top: 0, width: @width, height: @height}, &execution_blk

      Shoes.register self
      @gui.open
    end

    def window(options={}, &block)
      options.merge! owner: self
      self.class.new(options, &block)
    end

    def width
      @top_slot ? @gui.width : @width
    end

    def height
      @top_slot ? @gui.height : @height
    end

    def left; 0 end
    def top; 0 end

    def quit
      Shoes.unregister self
      @gui.quit
    end

    def started?
      @gui.started
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
      @top_slot.add_child child
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
  end
end
