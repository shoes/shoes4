class Shoes
  module Swt
    # This class is intended as the single click listener held onto by the app.
    # That lets us control dispatch of events to our DSL objects however we
    # please, instead of relying on whatever SWT thinks is right. See #882.
    class ClickListener
      include ::Swt::Widgets::Listener

      attr_reader :clickable_elements

      def initialize(swt_app)
        @clickable_elements = []
        @clicks   = {}
        @releases = {}
        swt_app.add_listener ::Swt::SWT::MouseDown, self
        swt_app.add_listener ::Swt::SWT::MouseUp, self
      end

      def add_click_listener(dsl, block)
        add_clickable_element(dsl)
        @clicks[dsl] = block
      end

      def add_release_listener(dsl, block)
        add_clickable_element(dsl)
        @releases[dsl] = block
      end

      def remove_listeners_for(dsl)
        @clickable_elements.delete(dsl)
        @clicks.delete(dsl)
        @releases.delete(dsl)
      end

      def add_clickable_element(dsl)
        @clickable_elements << dsl unless @clickable_elements.include?(dsl)
      end

      def handle_event(event)
        handlers = event.type == ::Swt::SWT::MouseDown ? @clicks : @releases
        handlers = handlers.to_a.
          select { |dsl, _| !dsl.respond_to?(:hidden?) || !dsl.hidden? }.
          select { |dsl, _| dsl.in_bounds?(event.x, event.y) }

        dsl, block = handlers.last
        eval_block(event, dsl, block)
      end

      def eval_block(event, dsl, block)
        return if block.nil?

        if dsl.pass_coordinates?
          block.call event.button, event.x, event.y
        else
          block.call(dsl)
        end
      end
    end
  end
end
