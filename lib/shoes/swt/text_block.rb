module Shoes
  module Swt
    class TextBlock
      def initialize(dsl, opts = nil)
        @dsl = dsl
        @opts = opts
        @container = @dsl.app.gui.real
        @container.add_paint_listener(TbPainter.new(@dsl, opts))
      end

      def redraw
        @container.redraw
      end

      def move x, y
        redraw unless @container.disposed?
        @left, @top, @width, @height = x, y, @dsl.width, @dsl.height
      end

      def get_height
        tl, font = set_styles
        tl.setWidth @dsl.width
        tl.getBounds(0, @dsl.text.length - 1).height.tap{font.dispose}
      end

      def get_size
        tl, font = set_styles
        gb = tl.getBounds(0, @dsl.text.length - 1).tap{font.dispose}
        return gb.width, gb.height
      end

      def set_styles
        tl = ::Swt::TextLayout.new Shoes.display
        tl.setText @dsl.text
        tl.setSpacing(@opts[:leading] || 4)
        font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size, ::Swt::SWT::NORMAL
        style = ::Swt::TextStyle.new font, nil, nil
        tl.setStyle style, 0, @dsl.text.length - 1
        return tl, font
      end

      private

      class TbPainter
        include Common::Resource

        def initialize(dsl, opts)
          @dsl = dsl
          @opts = opts
          @tl = ::Swt::TextLayout.new Shoes.display
        end

        def paintControl(paint_event)
          gc = paint_event.gc
          gcs_reset gc
          @tl.setText @dsl.text
          set_styles
          if @dsl.width
            @tl.setWidth @dsl.width
            @tl.draw gc, @dsl.left.to_i, @dsl.top.to_i
          end
        end

        def set_styles
          @tl.setJustify @opts[:justify]
          @tl.setSpacing(@opts[:leading] || 4)
          @tl.setAlignment case @opts[:align]
            when 'center'; ::Swt::SWT::CENTER
            when 'right'; ::Swt::SWT::RIGHT
            else ::Swt::SWT::LEFT
            end
          font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size, ::Swt::SWT::NORMAL
          fgc = @opts[:stroke] ? ::Swt::Color.new(Shoes.display, @opts[:stroke].red, @opts[:stroke].green, @opts[:stroke].blue) : nil
          bgc = @opts[:fill] ? ::Swt::Color.new(Shoes.display, @opts[:fill].red, @opts[:fill].green, @opts[:fill].blue) : nil
          style = ::Swt::TextStyle.new font, fgc, bgc
          @tl.setStyle style, 0, @dsl.text.length - 1
          @gcs << font

          @opts[:text_styles].each do |st|
            font, ft, fg, bg, cmds, small = @dsl.font, ::Swt::SWT::NORMAL, fgc, bgc, [], 1
            nested_styles(@opts[:text_styles], st).each do |e|
              case e[0].style
              when :strong
                ft = ft | ::Swt::SWT::BOLD
              when :em
                ft = ft | ::Swt::SWT::ITALIC
              when :fg
                fg = ::Swt::Color.new Shoes.display, e[0].color.red, e[0].color.green, e[0].color.blue
              when :bg
                bg = ::Swt::Color.new Shoes.display, e[0].color.red, e[0].color.green, e[0].color.blue
              when :ins
                cmds << "underline = true"
              when :del
                cmds << "strikeout = true"
              when :sub
                small *= 0.8
                cmds << "rise = -5"
              when :sup
                small *= 0.8
                cmds << "rise = 5"
              when :code
                font = "Lucida Console"
              when :link
                # not yet implemented
              else
              end
            end
            ft = ::Swt::Font.new Shoes.display, font, @dsl.font_size*small, ft
            style = ::Swt::TextStyle.new ft, fg, bg
            cmds.each{|cmd| eval "style.#{cmd}"}
            @tl.setStyle style, st[1].first, st[1].last
            @gcs << ft
          end if @opts[:text_styles]
        end

        def nested_styles styles, st
          styles.map do |e|
            (e[1].first <= st[1].first and st[1].last <= e[1].last) ? e : nil
          end - [nil]
        end
      end
    end

    class Banner < TextBlock; end
    class Title < TextBlock; end
    class Subtitle < TextBlock; end
    class Tagline < TextBlock; end
    class Caption < TextBlock; end
    class Para < TextBlock; end
    class Inscription < TextBlock; end
  end
end
