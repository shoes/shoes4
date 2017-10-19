# frozen_string_literal: true
class Shoes
  module Common
    module Remove
      def remove
        parent&.remove_child self
        gui&.remove if gui&.respond_to?(:remove)
        @app&.remove_mouse_hover_control(self) if defined?(@app)
      end
    end
  end
end
