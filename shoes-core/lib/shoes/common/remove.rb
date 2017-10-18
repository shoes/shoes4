# frozen_string_literal: true
class Shoes
  module Common
    module Remove
      def remove
        parent&.remove_child self
        gui&.remove if gui&.respond_to?(:remove)
        if defined?(@app)
          @app&.remove_mouse_hover_control(self)
        end
      end
    end
  end
end
