class Shoes
  module Common
    class StyleNormalizer
      include Color::DSLHelpers
      def normalize(orig_style)
        normalized_style = {}
        [:fill, :stroke].each do |s|
          normalized_style[s] = pattern(orig_style[s]) if orig_style[s]
        end
        orig_style.merge(normalized_style)
      end
    end
  end
end
