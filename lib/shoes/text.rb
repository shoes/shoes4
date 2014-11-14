class Shoes
  class Text
    include Common::Inspect

    attr_reader :to_s, :texts, :color
    attr_accessor :parent_text, :text_block

    def initialize(texts, color = nil)
      @texts       = texts
      @color       = color
      @to_s        = @texts.map(&:to_s).join
      @parent_text = nil
      @text_block  = nil
    end

    def app
      @parent_text.app
    end

    def inspect
      super.insert(-2, %( "#{self}"))
    end
  end
end
