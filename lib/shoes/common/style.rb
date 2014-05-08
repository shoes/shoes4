class Shoes
  module Common
    # Style methods.
    module Style 

      DEFAULTS = {
        fill:        Shoes::COLORS[:black],
        stroke:      Shoes::COLORS[:black],
        strokewidth: 1,
        wedge:       false
      }

      StyleGroups = {
        art_styles:    [:click, :fill, :stroke, :strokewidth],
        common_styles: [:displace_left, :displace_top, :hidden],
        dimensions:    [:bottom, :height, :left, :right, :top, :margin, 
                        :margin_bottom, :margin_left, :margin_right, 
                        :margin_top, :width]
      }

      def style_with(*styles)

        @supported_styles = []

        #unpack style groups
        styles.each do |style|
          if StyleGroups[style]
            StyleGroups[style].each{|style| @supported_styles << style}
          else
            @supported_styles << style
          end
        end

        #define getter and setter methods for each style
        ObjectSpace.each_object(Class) do |klass|
          if klass == self.class
            @style = Hash.new

            @supported_styles.each do |style|
              #Skip dimensions since they already have setters and getters defined
              unless StyleGroups[:dimensions].include?(style)
                #getter
                self.instance_eval %Q{
                def #{style}
                  @style[:#{style}]
                end
                }

                #setter
                self.instance_eval %Q{
                def #{style}=(val)
                  @style[:#{style}]=val
                end
                }
              end

              #Now set style from global defaults dimensions or class defaults
              case
              when StyleGroups[:dimensions].include?(style)
                #if dimension, load from dimensions
                @style[style] = self.send(style)

              when @app.element_styles[klass] && @app.element_styles[klass].include?(style)
                #check for style at the element level
                @style[style] = @app.element_styles[klass][style]

              when DEFAULTS[style] != nil
                #check styles at the default level
                @style[style] = DEFAULTS[style]
              end

            end
          end
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
