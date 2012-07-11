require 'shoes/color'

module Shoes
  module Swt
    class EditLine
      include Common::Child

      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk
        @real = ::Swt::Widgets::Text.new(@parent.real,
          ::Swt::SWT::SINGLE)

        # since the widget as well as app.background is white,
        # the widget won't be distinguishable from the background
        # unless I change its background color
        @real.background = COLORS[:lightgrey].to_native
      end

      def text=(value)
        @real.text = value
      end

      def move(left, top)
        unless @real.disposed?
          # If this element is part of a layout, we need to pop it into its own
          # composite layer before moving it, so the rest of of the elements in
          # the layout can reflow.
          if @parent.real.get_layout
            old_parent_real = @parent.real
            app = @parent.app # weird bug
            app_real = app.real
            new_composite = ::Swt::Widgets::Composite.new(app_real,
              ::Swt::SWT::NO_BACKGROUND)
            @real.dispose
            new_composite.set_layout nil
            @real = ::Swt::Widgets::Text.new(new_composite, ::Swt::SWT::SINGLE).tap do |edit_line|
              edit_line.background = COLORS[:lightgrey].to_native
              edit_line.pack
            end
            new_composite.set_bounds(0, 0, app_real.size.x, app_real.size.y)
            new_composite.move_above(old_parent_real)
            old_parent_real.layout
          end
          @real.set_location left, top
          @real.redraw
        end
      end
    end
  end
end


