#swt

module Shoes
  module Swt
    module List_box
      def gui_list_box_init
        @gui_element = ::Swt::Widgets::Combo.new(@parent.gui.real,
          ::Swt::SWT::READ_ONLY)
      end

      def gui_update_items(values)
        @gui_element.items = values
        @gui_element.text  = values.first
      end

      def text
        v=@gui_element.text
        v == "" ? nil : v
      end
    end
  end
end

module Shoes
  class List_box
    include Shoes::Swt::List_box
  end
end
