module Shoes
  module Swt
    module Text_block

      def gui_textblock_init
        puts "the text is: #{@text}"
      end

      def gui_update_text
        puts "the text has been updated"
      end

    end
  end
end

module Shoes
  class Text_block
    include Shoes::Swt::Text_block
  end
end
