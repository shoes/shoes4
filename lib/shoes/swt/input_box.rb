class Shoes
  module Swt
    # Class is used by edit_box and edit_line
    class InputBox
      include Common::Child
      include Common::Clear
      include Common::Toggle
      include Common::UpdatePosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :real, :dsl

      def initialize(dsl, parent, text_options)
        @dsl          = dsl
        @parent       = parent
        @text_options = text_options

        @real = ::Swt::Widgets::Text.new(@parent.real, text_options)
        @real.set_size dsl.element_width, dsl.element_height
        @real.set_text dsl.initial_text.to_s
        @real.add_modify_listener do |event|
          source = event.source

          if event.class == Java::OrgEclipseSwtEvents::ModifyEvent && source.class == Java::OrgEclipseSwtWidgets::Text
            # return immediately if the text matches the last entry to avoid going into infinite loop
            return if source.text == last_text
          end

          @dsl.call_change_listeners
        end
      end

      def text
        @real.text
      end

      def text=(value)
        @last_text = @real.text
        @real.text = value
      end

      def enabled(value)
        @real.enable_widget value
      end

      def selected_text(start_index, final_index)
        final_index ? @real.set_selection(start_index, final_index) : @real.set_selection(start_index)
      end

      private

      def last_text() @last_text; end
    end
  end
end
