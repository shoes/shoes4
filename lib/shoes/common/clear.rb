class Shoes
  module Common
    module Clear
      def clear
        # duplicate neeeded because iterating over an array and deleting from
        # it (as #remove) does is no good... #478
        my_contents = Array.new contents
        my_contents.each do |element|
          element.is_a?(Shoes::Slot) ? element.clear : element.remove
        end
        contents.clear
      end
    end
  end
end