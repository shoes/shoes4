class Shoes
  module Common
    module Inspect
      def to_s
        "(#{self.class.name})"
      end

      # Object hex representation from https://github.com/michaeldv/awesome_print
      def inspect
        "(#{self.class.name}:#{'0x%08x' % (object_id * 2)})"
      end
    end
  end
end
