# frozen_string_literal: true
class Shoes
  module Swt
    class ListBox
      include Common::Focus
      include Common::Remove
      include Common::Visibility
      include Common::UpdatePosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :app

      def initialize(dsl, app)
        @dsl = dsl
        @app = app
        @real = ::Swt::Widgets::Combo.new(
          @app.real,
          ::Swt::SWT::DROP_DOWN | ::Swt::SWT::READ_ONLY
        )
        @real.set_size dsl.element_width, dsl.element_height
        @real.add_selection_listener do |_event|
          @dsl.call_change_listeners
        end
        update_items

        # Set initial selection without triggering callbacks!
        choice = @dsl.style[:choose]
        @real.text = choice if choice
      end

      def update_items
        # Keep original selection to restore after resetting the list
        text = @real.text

        @real.set_items(*@dsl.items.to_a.map(&:to_s))
        @real.text = text
      end

      def text
        text = @real.text
        text == '' ? nil : text
      end

      def choose(item)
        @real.text = item
        @dsl.call_change_listeners
      end

      def enabled(value)
        @real.enable_widget value
      end
    end
  end
end
