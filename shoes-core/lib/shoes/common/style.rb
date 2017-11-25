# frozen_string_literal: true

# The general Style module handles the many optional styles that may be passed
# to shoes elements upon creates as well as the fact that they can later on be
# altered through the #style method.
#
# Relies upon:
#   @app - a reference to the Shoes applications
class Shoes
  module Common
    module Style
      DEFAULT_STYLES = {
        rotate:      0,
        stroke:      Shoes::COLORS[:black],
        strokewidth: 1
      }

      STYLE_GROUPS = {
        art_styles:           [:angle, :cap, :click, :fill, :rotate, :stroke,
                               :strokewidth, :transform, :translate],
        common_styles:        [:displace_left, :displace_top, :hidden],
        dimensions:           [:bottom, :height, :left, :margin,
                               :margin_bottom, :margin_left, :margin_right,
                               :margin_top, :right, :top, :width],
        text_block_styles:    [:align, :click, :emphasis, :family, :fill, :font,
                               :justify, :kerning, :leading, :rise, :size, :stretch,
                               :strikecolor, :strikethrough, :stroke, :undercolor,
                               :underline, :weight, :wrap],
      }.freeze

      # Adds styles, or just returns current style if no argument
      def style(new_styles = nil)
        update_style(new_styles) if need_to_update_style?(new_styles)
        @style
      end

      def style_init(arg_styles, new_styles = {})
        default_element_styles = {}
        default_element_styles = self.class::STYLES if defined?(self.class::STYLES)
        create_style_hash
        @style.merge!(default_element_styles)
        merge_app_styles
        @style.merge!(@app.element_styles[self.class]) if @app.element_styles[self.class]
        @style.merge!(new_styles)
        @style.merge!(arg_styles)
        @style = StyleNormalizer.new.normalize(@style)

        set_hovers(@style)
      end

      def create_style_hash
        @style = {}
        supported_styles.each do |key|
          @style[key] = nil
        end
      end

      def merge_app_styles
        @app.style.each do |key, val|
          @style[key] = val if supported_styles.include? key
        end
      end

      module StyleWith
        def style_with(*styles)
          @supported_styles = []

          unpack_style_groups(styles)
          define_reader_methods
          define_writer_methods
        end

        def unpack_style_groups(styles)
          styles.each do |style|
            if STYLE_GROUPS[style]
              STYLE_GROUPS[style].each { |group_style| support_style group_style }
            else
              support_style style
            end
          end

          supported_styles = @supported_styles

          define_method("supported_styles") do
            supported_styles
          end
        end

        def define_reader_methods
          needs_readers = @supported_styles.reject do |style|
            method_defined?(style)
          end

          needs_readers.map(&:to_sym).each do |style|
            define_method style do
              @style[style]
            end
          end
        end

        def define_writer_methods
          needs_writers = @supported_styles.reject do |style|
            method_defined?("#{style}=")
          end

          needs_writers.map(&:to_sym).each do |style_key|
            define_method "#{style_key}=" do |new_style|
              send("style", style_key.to_sym => new_style)
            end
          end
        end

        private

        def support_style(group_style)
          @supported_styles << group_style
        end
      end # end of StyleWith module

      def self.included(klass)
        klass.extend StyleWith
      end

      private

      def update_style(new_styles)
        normalized_style = StyleNormalizer.new.normalize(new_styles)
        @style.merge! normalized_style

        set_dimensions(new_styles)
        set_visibility(new_styles)
        set_coloring(new_styles)
        set_hovers(new_styles)
        set_translate(new_styles)
        set_click(new_styles)
        set_state(new_styles)
      end

      # if dimension is set via style, pass info on to the dimensions setter
      def set_dimensions(new_styles)
        new_styles.each do |key, value|
          send("#{key}=", value) if STYLE_GROUPS[:dimensions].include?(key)
        end
      end

      def set_visibility(new_styles)
        return unless new_styles.include?(:hidden)
        update_visibility
      end

      def set_coloring(new_styles)
        update_fill   if new_styles.include?(:fill)
        update_stroke if new_styles.include?(:stroke)
      end

      def set_hovers(new_styles)
        hover(&new_styles[:hover]) if new_styles.include?(:hover)
        leave(&new_styles[:leave]) if new_styles.include?(:leave)
      end

      def set_translate(new_styles)
        clear_translate if new_styles.include?(:translate)
      end

      def set_click(new_styles)
        click(&new_styles[:click]) if new_styles.key?(:click)
      end

      def set_state(new_styles)
        update_from_state if new_styles.include?(:state)
      end

      def update_dimensions # so that @style hash matches actual values
        STYLE_GROUPS[:dimensions].each do |style|
          if respond_to?(style)
            value = send(style)
            @style[style] = value if value
          end
        end
      end

      def styles_with_dimensions?
        STYLE_GROUPS[:dimensions].any? { |dimension| @style.key? dimension }
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
