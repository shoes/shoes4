class Shoes
  module Swt
    module Common
      module Clickable
        attr_accessor :click_listener

        def click(block)
          app.click_listener.add_click_listener(dsl, block)
        end

        def release(block)
          app.click_listener.add_release_listener(dsl, block)
        end
      end
    end
  end
end
