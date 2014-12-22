class Shoes
  module Swt
    module Common
      module Remove
        def remove
          app.remove_paint_listener @painter
          remove_click_listeners
          @real.dispose unless @real.nil? || @real.disposed?
          dispose_held_resources
          dispose
        end

        def dispose_held_resources
          @color_factory.dispose unless @color_factory.nil?
        end

        # Classes should override to dispose of any Swt resources they create
        def dispose
        end

        private

        def remove_click_listeners
          app.click_listener.remove_listeners_for(dsl)
        end
      end
    end
  end
end
