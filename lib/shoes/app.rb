require 'shoes/element_methods'
require 'shoes/color'

def window(*a, &b)
  Shoes.app(*a, &b)
end


module Shoes
  SHOES_ICON = 'static/shoes-icon.png'

  def self.app(opts={}, &blk)
    Shoes::App.new(opts, &blk)
  end

  class App
    include Shoes::ElementMethods

    attr_reader :gui, :shell, :top_slot, :contents
    attr_accessor :elements
    attr_accessor :opts, :blk

    attr_accessor :width, :height, :resizable, :app_title
    attr_writer   :width, :height

    def initialize(opts={}, &blk)
      opts = default_options.merge(opts)

      self.width      = opts[:width]
      self.height     = opts[:height]
      self.app_title  = opts[:title]
      self.resizable  = opts[:resizable]
      self.opts       = opts

      @app = self
      @style = default_styles
      @contents = []

      @gui = Shoes.configuration.backend::App.new @app

      @top_slot = Flow.new self, {app: @app, left: 0, top: 0, width: @width, height: @height}, &blk if blk

      @gui.open
    end

    def add_child(child)
      @top_slot.add_child child
    end

    def default_options
      {
        :width  => 600,
        :height => 500,
        :title  => "Shoes 4",
        :resizable  => true,
        :background => white
      }
    end

    def default_styles
      {
        :stroke      => Shoes::COLORS[:black],
        :strokewidth => 1
      }
    end
  end
end
