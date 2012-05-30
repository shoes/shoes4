require 'white_shoes/common_methods'

module WhiteShoes
  # Shape methods
  #
  # Including classes must provide instance variables:
  #
  #     @x          - the current x-value
  #     @y          - the current y-value
  #
  module Shape
    attr_accessor :gui_container
    attr_accessor :gui_element

    def gui_init
      self.gui_element = "A new gui Shape"
    end

    def move_to(x, y)
      @x, @y = x, y
    end

    def line_to(x, y)
      @components << Shoes::Line.new(@x, @y, x, y, @style)
    end
  end
end

module Shoes
  class Shape
    include WhiteShoes::Shape
  end
end

