class Shoes
  class Span < Text
    def initialize(texts, styles = {})
      @style = styles
      super texts, styles.delete(:color)
    end

    def style
      if @parent && @parent.respond_to?(:style)
        @parent.style.merge(@style)
      else
        @style
      end
    end
  end
end
