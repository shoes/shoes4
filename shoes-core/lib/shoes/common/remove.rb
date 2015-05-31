class Shoes
  module Common
    module Remove
      def remove
        parent.remove_child self if parent
        gui.remove if gui && gui.respond_to?(:remove)

        @app.remove_mouse_hover_control(self) if @app
      end
    end
  end
end
