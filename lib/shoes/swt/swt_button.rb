module Shoes
  module Swt
    class SwtButton
      # The Swt parent object
      attr_reader :parent, :real

      def initialize(dsl, parent, type, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk

        @type = type
        @real = ::Swt::Widgets::Button.new(@parent.real, @type)
        @real.addSelectionListener(@blk) if @blk

        yield(@real) if block_given?

        @real.pack
        size = @real.getSize
        @dsl.width, @dsl.height = size.x, size.y
        parent.dsl.contents << @dsl
      end

      def focus
        @real.set_focus
      end

      private
      def swt_move(left, top, &block)
        unless @real.disposed?
          # If this element is part of a layout, we need to pop it into its own
          # composite layer before moving it, so the rest of of the elements in
          # the layout can reflow.
          if @parent.real.get_layout
            old_parent_real = @parent.real
            app_real = app.real
            new_composite = ::Swt::Widgets::Composite.new(app_real,
              ::Swt::SWT::NO_BACKGROUND)
            @real.dispose
            new_composite.set_layout nil
            @real = ::Swt::Widgets::Button.new(new_composite, @type).tap do |button|
              yield button unless block.nil?
              button.pack
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
