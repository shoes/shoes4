class Shoes
  module Common
    class StyleNormalizer
      include Color::DSLHelpers
      def normalize(orig_style, supported_styles)
        normalized_style = {}
        supported_styles.each do |s|
          if orig_style[s]
            if orig_style[s].class == Fixnum
              normalized_style[s] = orig_style[s]
            else
              normalized_style[s] = pattern(orig_style[s])
            end
          end
        end
        orig_style.merge(normalized_style)
      end
    end
  end
end
