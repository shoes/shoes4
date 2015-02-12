class Shoes
  module Common
    module Inspect
      def to_s
        "(#{self.class.name}#{to_s_details})"
      end

      # Object hex representation from https://github.com/michaeldv/awesome_print
      # Example:
      #   (Shoes::App:0x01234abc "Hello")
      def inspect
        "(#{self.class.name}:#{hexy_object_id}#{inspect_details})"
      end

      private

      # Additional details to include in the inspect representation.
      def inspect_details
        ''
      end

      # Additional details to include in the to_s representation.
      def to_s_details
        ''
      end

      def hexy_object_id
        sprintf('0x%08x', object_id * 2)
      end
    end
  end
end
