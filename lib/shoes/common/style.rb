class Shoes
  module Common
    # Style methods.
    module Style 

      STYLE_GROUPS = {
        art_styles:    [:click, :fill, :stroke, :strokewidth],
        common_styles: [:displace_left, :displace_top, :hidden],
        dimensions:    [:bottom, :height, :left, :right, :top, :margin, 
                        :margin_bottom, :margin_left, :margin_right, 
                        :margin_top, :width],
        text_styles:   [:align, :click, :emphasis, :family, :fill, :font, 
                        :justify, :kerning, :leading, :rise, :size, :stretch, 
                        :strikecolor, :strikethrough, :stroke, :undercolor, 
                        :underline, :smallcaps, :weight, :wrap]
      }
     
      # Adds style, or just returns current style if no argument
      # Returns the updated style
      def style(new_styles = nil)
        update_style(new_styles) if need_to_update_style?(new_styles)
        @style
      end
      
      
      module StyleWith
        def style_with(*styles)
          
          attr_reader :supported_styles
          @@supported_styles = []
          
          #unpack style groups
          styles.each do |style|
            if STYLE_GROUPS[style]
              STYLE_GROUPS[style].each{|style| @@supported_styles << style}
            else
              @@supported_styles << style
            end
          end

          #define setter and getter unless its a dimension
          @@supported_styles.map(&:to_sym).each do |style|
            next if STYLE_GROUPS[:dimensions].include?(style)

            define_method style do
              @style[style]
            end

            define_method "#{style}=" do |new_style|
              @style[style] = new_style
            end

          end

          def supported_styles
            @@supported_styles
          end
        end

      end

      def style_init
        @style = {}
        klass = self.class

        #Now set style from dimensions, global-styles or element-styles
        self.singleton_class.supported_styles.each do |style|
          case
          when STYLE_GROUPS[:dimensions].include?(style)
            #if dimension, load from dimensions
            @style[style] = self.send(style)

          when @app.element_styles[klass] && @app.element_styles[klass].include?(style)
            #check for style at the element level
            @style[style] = @app.element_styles[klass][style]

          when @app.style[style]
            @style[style] = @app.style[style]
          end
        end
      end

      def self.included(klass)
        klass.extend StyleWith
      end

      private
      def update_style(new_styles)
        normalized_style = StyleNormalizer.new.normalize(new_styles)
        @style.merge! normalized_style

        #call dimensions setter if style is a dimension
        new_styles.each do |style|
          next unless STYLE_GROUPS[:dimensions].include?(style[0])
          self.send("#{style[0]}=".to_sym, style[1])
        end
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
