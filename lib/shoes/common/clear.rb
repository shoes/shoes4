class Shoes
  module Common
    module Clear
      def clear
        contents = @contents.dup
        contents.each do |e|
          e.is_a?(Shoes::Slot) ? e.clear : e.remove
        end
        @contents.clear
      end
    end
  end
end