class Shoes
  module Swt
    module Common
      module Clickable
        attr_accessor :click_listener

        # object = self is there for compatibility reasons for now
        # it's for link (defined in text.rb) and the listener is added in the
        # swt/text_block.rb ... moving it around would be too hard now
        def clickable(object = self, block)
          app.click_listener.add_click_listener(object, block)
        end

        def click(block)
          app.click_listener.add_click_listener(self, block)
        end

        def release(block)
          app.click_listener.add_release_listener(self, block)
        end
      end
    end
  end
end
