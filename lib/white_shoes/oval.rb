require 'white_shoes/common_methods'

module WhiteShoes
  # Oval methods
  module Oval
    attr_accessor :gui_container
    attr_accessor :gui_element

    def gui_init
      self.gui_element = "A new gui Oval"
    end
  end
end

module Shoes
  class Oval
    include WhiteShoes::Oval
  end
end


