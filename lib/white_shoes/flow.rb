
module WhiteShoes
# flow takes these options
#   :margin - integer - add this many pixels to all 4 sides of the layout

  module Flow

    def gui_flow_init
      self.gui_container = "A new Container"
    end

    def gui_flow_add_to_parent

    end
  end

end


module Shoes
  class Flow
    include WhiteShoes::Flow
  end
end

