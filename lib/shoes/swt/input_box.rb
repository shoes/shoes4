require 'shoes/color'

module Shoes
  module Swt
    # Class is used by edit_box and edit_line
    class InputBox
      include Common::Child

      def initialize(dsl, parent, blk, text_options)
        @dsl = dsl
        @parent = parent
        @blk = blk
        @text_options = text_options

        @real = ::Swt::Widgets::Text.new(@parent.real, text_options)
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
            @real = ::Swt::Widgets::Text.new(new_composite, @text_options).tap do |edit_line|
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
