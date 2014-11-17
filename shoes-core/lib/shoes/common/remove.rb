class Shoes
  module Common
    module Remove
      def remove
        parent.remove_child self if parent
        gui.remove if gui && gui.respond_to?(:remove)
      end
    end
  end
end
