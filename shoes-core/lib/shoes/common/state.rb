class Shoes
  module Common
    module State
      DISABLED_STATE = "disabled"

      def after_initialize(*_)
        super
        update_enabled
      end

      def state=(value)
        style(state: value)
        update_enabled
      end

      def state_options(opts)
        self.state = opts[:state]
      end

      private

      def enabled?
        !(state.to_s == DISABLED_STATE)
      end

      def update_enabled
        @gui.enabled(enabled?)
      end
    end
  end
end
