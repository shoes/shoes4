class Shoes
  module Common
    module State
      attr_reader :state

      def state=(value)
        @state = value
        @gui.enabled value.nil?
      end

      def state_options(opts)
        self.state = opts[:state]
      end
    end
  end
end
