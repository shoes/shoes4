class Shoes
  module Swt
    module Common
      module Clickable
        attr_accessor :click_listener

        # object = self is there for compatibility reasons for now
        # it's for link (defined in text.rb) and the listener is added in the
        # swt/text_block.rb ... moving it around would be too hard now
        def clickable(object = self, block)
          add_listener_for object, ::Swt::SWT::MouseDown, block
        end

        def click(block)
          remove_listener_for ::Swt::SWT::MouseDown
          add_listener_for ::Swt::SWT::MouseDown, block
        end

        def release(block)
          remove_listener_for ::Swt::SWT::MouseUp
          add_listener_for ::Swt::SWT::MouseUp, block
        end

        private

        def add_listener_for(swt_object = self, event, block)
          # dsl objects take care of in bounds checking etc.
          dsl_object = swt_object.dsl
          listener = ClickListener.new(dsl_object, block)
          swt_object.click_listener = listener
          app.add_clickable_element dsl_object
          app.add_listener event, listener
        end

        def remove_listener_for(swt_object = self, event)
          dsl_object = swt_object.dsl
          app.clickable_elements.delete(dsl_object)
          app.remove_listener event, swt_object.click_listener
        end

        class ClickListener
          include ::Swt::Widgets::Listener

          def initialize(clickable_object, block)
            @clickable_object = clickable_object
            @block            = block
          end

          def handleEvent(mouse_event)
            return if @clickable_object.respond_to?(:hidden?) && @clickable_object.hidden?
            if @clickable_object.in_bounds?(mouse_event.x, mouse_event.y)
              eval_block mouse_event
            end
          end

          def eval_block(mouse_event)
            if @clickable_object.pass_coordinates?
              @block.call mouse_event.button, mouse_event.x, mouse_event.y
            else
              @block.call @clickable_object
            end
          end
        end
      end
    end
  end
end
