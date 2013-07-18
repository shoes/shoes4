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

        def click(&block)
          add_listener_for ::Swt::SWT::MouseDown, block
        end
    
        def release(&block)
          add_listener_for ::Swt::SWT::MouseUp, block
        end

        def clickable_options(opts)
          click(&opts[:click]) if opts[:click]
        end

        private
        def add_listener_for(object = self, event, block)
          if object.respond_to? :dsl
            dsl_object = object.dsl
          else
            dsl_object = object
          end
          listener = ClickListener.new(dsl_object, block)
          object.click_listener = listener
          app_gui = dsl_object.app.gui
          app_gui.add_clickable_element dsl_object
          app_gui.real.addListener event, listener
        end


        class ClickListener
          include ::Swt::Widgets::Listener

          def initialize(clickable_object, block)
            @clickable_object = clickable_object
            @block            = block
          end

          def handleEvent(mouseEvent)
            if @clickable_object.in_bounds?(mouseEvent.x, mouseEvent.y)
              @block.call mouseEvent.button, mouseEvent.x, mouseEvent.y
            end
          end
        end

      end
    end
  end
end
