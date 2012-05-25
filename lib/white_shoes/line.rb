require 'white_shoes/common_methods'

module WhiteShoes
  # Line methods
  module Line
    attr_accessor :gui_container
    attr_accessor :gui_element

    def gui_init
      self.gui_element = "A new gui Line"
    end
  end
end

module Shoes
  class Line
    include WhiteShoes::Line
  end
end


