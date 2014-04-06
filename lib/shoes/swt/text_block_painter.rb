class Shoes
  module Swt
    class TextBlockPainter
      include ::Swt::Events::PaintListener
      include Common::Resource

      attr_reader :app
      def initialize(dsl)
        @dsl = dsl
        @opts = @dsl.opts
        @app = @dsl.app.gui
      end

      def paintControl(paint_event)
        gcs_reset(paint_event.gc)
        return if @dsl.hidden?

        fitted_layouts = @dsl.gui.fitted_layouts
        layouts = FittedTextLayoutCollection.new(fitted_layouts, default_text_styles)
        layouts.style_from(@opts)
        layouts.style_segment_ranges(@dsl.text_styles)
        layouts.create_links(@dsl.text_styles)
        layouts.draw(paint_event.gc)

        draw_text_cursor
      end

      def draw_text_cursor
        TextBlockCursorPainter.new(@dsl, @dsl.gui.fitted_layouts).draw
      end

      private

      def default_text_styles
        {
          :fg          => @opts[:fg],
          :bg          => @opts[:bg],
          :strikecolor => @opts[:strikecolor],
          :undercolor  => @opts[:undercolor],
          :font_detail => {
            :name   => @dsl.font,
            :size   => @dsl.font_size,
            :styles => [::Swt::SWT::NORMAL]
          }
        }
      end
    end
  end
end
