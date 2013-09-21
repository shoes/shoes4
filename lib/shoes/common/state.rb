class Shoes
  module Common
    module State
      def state
        @state
      end

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
