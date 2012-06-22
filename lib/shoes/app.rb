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

    attr_reader :gui
    attr_accessor :elements
    attr_accessor :opts, :blk

    attr_accessor :width, :height, :title, :resizable
    attr_writer   :background, :width, :height

    def initialize(opts={}, &blk)
      opts = default_options.merge(opts)

      self.width      = opts[:width]
      self.height     = opts[:height]
      self.title      = opts[:title]
      self.resizable  = opts[:resizable]
      self.background = opts[:background]
      self.opts       = opts

      @app = self
      @style = default_styles

      @gui = Shoes.configuration.backend::App.new @app

      instance_eval &blk if blk

      @gui.open
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

    # If background is called without any options this
    # will simply return it's value. Otherwise it will
    # interpret the call as the user wanting to set the
    # background, in which case it will call gui_background
    def background(*opts)
      return @background if opts.empty?
      @background = opts[0] if opts.size == 1
      @gui.background opts
    end

  end
end
