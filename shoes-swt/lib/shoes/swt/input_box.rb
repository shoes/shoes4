# frozen_string_literal: true

class Shoes
  module Swt
    # Class is used by edit_box and edit_line
    class InputBox
      include Common::Focus
      include Common::Remove
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::UpdatePosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :real, :dsl, :app
      attr_writer :readonly

      def initialize(dsl, app, text_options)
        @dsl = dsl
        @app = app

        @real = ::Swt::Widgets::Text.new(@app.real, text_options)
        @real.set_size dsl.element_width, dsl.element_height
        @real.set_text dsl.style[:text]
        @real.add_modify_listener do |event|
          @dsl.call_change_listeners unless nothing_changed?(event)
        end

        @real.add_verify_listener do |event|
          event.doit = false if @readonly
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
        @real.enabled = value
      end

      def highlight_text(start_index, final_index)
        @real.set_selection(start_index, final_index)
      end

      def caret_to(index)
        @real.set_selection(index)
      end

      private

      def nothing_changed?(event)
        source = event.source
        event.instance_of?(Java::OrgEclipseSwtEvents::ModifyEvent) &&
          source.instance_of?(Java::OrgEclipseSwtWidgets::Text) &&
          source.text == @last_text
      end
    end

    class EditLine < InputBox
      DEFAULT_STYLES = ::Swt::SWT::SINGLE | ::Swt::SWT::BORDER
      def initialize(dsl, app)
        styles = DEFAULT_STYLES
        styles |= ::Swt::SWT::PASSWORD if dsl.secret?
        super(dsl, app, styles)
      end
    end

    class EditBox < InputBox
      DEFAULT_STYLES = ::Swt::SWT::MULTI | ::Swt::SWT::BORDER | ::Swt::SWT::WRAP | ::Swt::SWT::V_SCROLL
      def initialize(dsl, app)
        super(dsl, app, DEFAULT_STYLES)
      end
    end
  end
end
