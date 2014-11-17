class Shoes
  class Span < Text
    def initialize(texts, styles = {})
      @style = styles
      super texts, styles.delete(:color)
    end

    def style
      if @parent_text && @parent_text.respond_to?(:style)
        @parent_text.style.merge(@style)
      else
        @style
      end
    end
  end
end
