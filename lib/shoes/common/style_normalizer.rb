class Shoes
  module Common
    class StyleNormalizer
      include Color::DSLHelpers
      def normalize(styles, supported_styles)
        normalized_style = {}
        supported_styles.each do |s|
          if orig_style[s]
            normalized_style[s] = pattern(orig_style[s])
          end
        end
        orig_style.merge(normalized_style)
      end
    end
  end
end
