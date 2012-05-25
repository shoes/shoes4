module WhiteShoes
    module Button
      def gui_button_init 
        self.gui_element = "A new gui Button"
      end
    end

end

module Shoes
  class Button
    include WhiteShoes::Button
  end
end

