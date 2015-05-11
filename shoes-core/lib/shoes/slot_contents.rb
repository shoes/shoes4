class Shoes
  class SlotContents < SimpleDelegator
    include Common::Inspect

    def initialize
      @contents         = []
      @prepending       = false
      @prepending_index = 0
      super(@contents)
    end

    def prepending?
      @prepending
    end

    def add_element(element)
      if @prepending
        prepend_element element
      else
        append_element element
      end
    end

    def prepend(&blk)
      @prepending_index = 0
      @prepending = true
      blk.call
      @prepending = false
    end

    def clear
      # reverse_each is important as otherwise we always miss to delete one
      # element
      @contents.reverse_each do |element|
        element.is_a?(Shoes::Slot) ? element.clear : element.remove
      end
      @contents.clear
    end

    private

    def inspect_details
      " @size=#{size} @prepending=#{@prepending} @prepending_index=#{@prepending_index}"
    end

    def append_element(element)
      @contents << element
    end

    def prepend_element(element)
      @contents.insert @prepending_index, element
      @prepending_index += 1
    end
  end
end
