module Shoes
  module Swt
  # flow takes these options
  #   :margin - integer - add this many pixels to all 4 sides of the layout

    module Flow

      def gui_flow_init
        self.gui = container = ::Swt::Widgets::Composite.new(self.parent_gui_container, ::Swt::SWT::NO_BACKGROUND)

        # RowLayout is horizontal by default, wrapping by default
        layout = ::Swt::Layout::RowLayout.new

        # set the margins
        set_margin(layout)

        if self.width && self.height
          container.setSize(self.width, self.height)
        end

        container.setLayout(layout)
      end

      # Please remove when converted to class :)
      def real
        self.gui
      end

      def gui_flow_add_to_parent
        #self.parent_gui_container.add(self.gui_container)
      end

      # Add this many pixels to margins on layout
      def set_margin(layout)
        if margin_pixels = self.margin
          layout.marginTop = margin_pixels
          layout.marginRight = margin_pixels
          layout.marginBottom = margin_pixels
          layout.marginLeft = margin_pixels
        end
      end
    end
  end
end


module Shoes
  class Flow
    include Shoes::Swt::Flow
  end
end

