class Shoes
  module Common
    # Style methods.
    module Style 

      DEFAULT_STYLES = {
        fill:        Shoes::COLORS[:black],
        stroke:      Shoes::COLORS[:black],
        strokewidth: 1 
      }

      STYLE_GROUPS = {
        art_styles:    [:click, :fill, :stroke, :strokewidth],
        common_styles: [:displace_left, :displace_top, :hidden],
        dimensions:    [:bottom, :height, :left, :margin, 
                        :margin_bottom, :margin_left, :margin_right, 
                        :margin_top, :right, :top, :width],
                        text_styles:   [:align, :click, :emphasis, :family, :fill, :font, 
                                        :justify, :kerning, :leading, :rise, :size, :stretch, 
                                        :strikecolor, :strikethrough, :stroke, :undercolor, 
                                        :underline, :smallcaps, :weight, :wrap]
      }

      # Adds styles, or just returns current style if no argument
      def style(new_styles = nil)
        update_style(new_styles) if need_to_update_style?(new_styles)
        update_dimensions
        @style
      end 

      module StyleWith
        def style_with(*styles)

          def self.supported_styles
            @supported_styles
          end

          @supported_styles = []

          #unpack style groups
          styles.each do |style|
            if STYLE_GROUPS[style]
              STYLE_GROUPS[style].each{|style| @supported_styles << style}
            else
              @supported_styles << style
            end
          end

          #define setter and getter unless its a dimension
          @supported_styles.map(&:to_sym).each do |style|
            next if STYLE_GROUPS[:dimensions].include?(style)

            define_method style.to_s do
              @style[style]
            end

            define_method "#{style}=" do |new_style|
              @style[style] = validate_style(new_style)
            end

          end
        end
      end

      def style_init(opts, new_styles)
        default_element_styles = self.class::STYLES || {}

        @style = @app.style.merge(default_element_styles)
        @style.merge!(@app.element_styles[self.class]) if @app.element_styles[self.class]
        @style.merge!(new_styles)
        @style.merge!(opts)
      end

      def self.included(klass)
        klass.extend StyleWith
      end

      private

      def validate_style(style)
        style
        # TODO add code which knows which styles are supposed to get what kinds
        # of data. And raises an exception when the wrong kind is given
        #
      end

      def update_style(new_styles)
        normalized_style = StyleNormalizer.new.normalize(new_styles)
        set_dimensions(new_styles)
        @style.merge! normalized_style
      end

      def set_dimensions(new_styles)
        new_styles.each do |key, value|
          next unless STYLE_GROUPS[:dimensions].include?(key)
          self.send(key.to_s+"=", value)
        end
      end

      def update_dimensions #so that @style hash matches actual values
        STYLE_GROUPS[:dimensions].each do |style|
          #   @style[style] = self.send(style.to_s) #getting problems here
        end
      end

      def need_to_update_style?(new_styles)
        new_styles && style_changed?(new_styles)
      end

      # check necessary because update_style triggers a redraw in the redrawing
      # aspect and we want to avoid unnecessary redraws
      def style_changed?(new_styles)
        new_styles.each_pair.any? do |key, value|
          @style[key] != value
        end
      end

    end
  end
end
