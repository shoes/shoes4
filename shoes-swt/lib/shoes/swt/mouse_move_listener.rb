class Shoes
  module Swt
    class MouseMoveListener
      include ::Swt::Events::MouseMoveListener

      def initialize(app)
        @app = app
      end

      def mouse_move(mouse_event)
        @app.dsl.mouse_pos = [mouse_event.x, mouse_event.y]
        @app.dsl.mouse_motion.each { |blk| eval_move_block blk, mouse_event }
        mouse_shape_control mouse_event
        mouse_leave_control mouse_event
        mouse_hover_control mouse_event
      end

      private

      def eval_move_block(blk, event)
        blk.call event.x, event.y
      end

      def mouse_shape_control(mouse_event)
        cursor = if cursor_over_clickable_element? mouse_event
                   ::Swt::SWT::CURSOR_HAND
                 else
                   ::Swt::SWT::CURSOR_ARROW
                 end
        @app.shell.setCursor Shoes.display.getSystemCursor(cursor)
      end

      def mouse_leave_control(mouse_event)
        @app.dsl.mouse_hover_controls.each do |element|
          if !mouse_on?(element, mouse_event) && element.hovered?
            element.mouse_left
          end
        end
      end

      def mouse_hover_control(mouse_event)
        @app.dsl.mouse_hover_controls.each do |element|
          if mouse_on?(element, mouse_event) && !element.hovered?
            element.mouse_hovered
          end
        end
      end

      def mouse_on?(element, mouse_event)
        element_visible?(element) && element.in_bounds?(mouse_event.x, mouse_event.y)
      end

      def element_visible?(element)
        if element.respond_to?(:visible?)
          element.visible?
        else
          false
        end
      end

      def cursor_over_clickable_element?(mouse_event)
        @app.clickable_elements.any? do |element|
          mouse_on? element, mouse_event
        end
      end
    end
  end
end
