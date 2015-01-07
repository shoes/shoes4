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

      protected

      # Creates a new string with details placed before last character
      # of string.
      #
      # Example:
      #
      # add_detail_to_inspect("(Shoes::Object)", 'o="eyelet"')
      #     #=> (Shoes::Object o="eyelet")
      def add_detail_to_inspect(string, detail)
        "#{string.chop}#{detail}#{string[-1]}"
      end
    end
  end
end
