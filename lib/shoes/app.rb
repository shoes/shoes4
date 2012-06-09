require 'shoes/element_methods'
require 'shoes/color'

def window(*a, &b)
  Shoes.app(*a, &b)
end


module Shoes

  def self.app(opts={}, &blk)
    Shoes::App.new(opts, &blk)
  end

  class App
    include Shoes::ElementMethods

    attr_accessor :elements, :gui_container
    attr_accessor :opts, :blk

    attr_accessor :width, :height, :title, :resizable
    attr_writer   :background

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

      gui_init

      instance_eval &blk if blk

      gui_open
    end

    def default_options
      {
        :width  => 600,
        :height => 500,
        :title  => "Shoooes!",
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
