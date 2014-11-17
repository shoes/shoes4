class Shoes
  module Swt
    module Common
      # Behavior for elements that act as children of other elements
      module Child
        # Finds the current app by asking parent elements, all the way
        # up to the App
        #
        # @return [Shoes::Swt::App] The current app
        def app
          parent.app
        end
      end
    end
  end
end
