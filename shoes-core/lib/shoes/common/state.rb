class Shoes
  module Common
    module State
      DISABLED_STATE = "disabled".freeze

      def after_initialize(*_)
        super
        update_from_state
      end

      def state=(value)
        style(state: value)
      end

      def enabled?
        !(state.to_s == DISABLED_STATE)
      end

      def update_from_state
        @gui.enabled(enabled?)
      end
    end
  end
end
