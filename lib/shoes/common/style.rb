=begin
class Class
  def style_accessor(*styles)
    styles.each do |style|
      name = style.to_s

      #getter
      self.class_eval %Q{
        def #{name}
          @style[#{style}]
        end
      }

      #setter
      self.class_eval %Q{
        def #{name}=(val)
          @style[#{style}]=val
        end
      }
    end
  end
end
=end

class Shoes
  module Common
    # Style methods.
    module Style 

      DEFAULTS = {
        fill:        Shoes::COLORS[:black],
        stroke:      Shoes::COLORS[:black],
        strokewidth: 1
      }

      def style_init(styles={})
        @supported_styles = []
        @style = styles

        styles.each do |key, value|
          @supported_styles << key
        end
      end

      # Adds style, or just returns current style if no argument
      # Returns the updated style
      def style(new_styles = nil)
        update_style(new_styles) if need_to_update_style?(new_styles)
        @style
      end


      private
      def update_style(new_styles)
        normalized_style = StyleNormalizer.new.normalize(new_styles, @supported_styles)
        @style.merge! normalized_style
      end

      def need_to_update_style?(new_styles)
        new_styles && style_changed?(new_styles)
      end

      # check necessary because update_style trigger a redraw in the redrawing
      # aspect and we want to avoid unnecessary redraws
      def style_changed?(new_styles)
        new_styles.each_pair.any? do |key, value|
          @style[key] != value
        end
      end
    end
  end
end
