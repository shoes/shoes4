class Shoes
  module Swt
    class TextBlock
      include Common::Clear

      def initialize(dsl, opts = nil)
        @dsl = dsl
        @opts = opts
        @container = @dsl.app.gui.real
        @painter = TbPainter.new @dsl, opts
        @container.add_paint_listener @painter
      end

      def redraw
        @container.redraw
      end

      def move x, y
        redraw unless @container.disposed?
        @left, @top, @width, @height = x, y, @dsl.width, @dsl.height
      end

      def get_height
        text_layout, font = set_styles
        text_layout.setWidth @dsl.width
        text_layout.getBounds(0, @dsl.text.length - 1).height.tap{font.dispose}
      end

      def get_size
        text_layout, font = set_styles
        gb = text_layout.getBounds(0, @dsl.text.length - 1).tap{font.dispose}
        return gb.width, gb.height
      end

      def set_styles
        text_layout = ::Swt::TextLayout.new Shoes.display
        text_layout.setText @dsl.text
        text_layout.setSpacing(@opts[:leading] || 4)
        font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size, ::Swt::SWT::NORMAL
        style = ::Swt::TextStyle.new font, nil, nil
        text_layout.setStyle style, 0, @dsl.text.length - 1
        return text_layout, font
      end
      
      def clear
        super
        clear_links
      end

      def replace *values
        clear_links
        @dsl.instance_variable_set :@text, values.map(&:to_s).join
        if @dsl.text.length > 1
          @dsl.fixed = (@dsl.text.split.length == 1)
          @dsl.width, @dsl.height = get_size
        end
        @opts[:text_styles] = @dsl.app.get_styles(values)
        redraw
      end


      private

      def clear_links
        @dsl.links.each do |link|
          @dsl.app.gui.clickable_elements.delete link
          ln = link.click_listener
          @container.remove_listener ::Swt::SWT::MouseDown, ln if ln
          @container.remove_listener ::Swt::SWT::MouseUp, ln if ln
        end
        @dsl.links.clear
      end

      class TbPainter
        #include org.eclipse.swt.events.PaintListener
        include ::Swt::Events::PaintListener
        include Common::Resource
        include Common::Clickable

        UNDERLINE_STYLES = {
          "single" => 0,
          "double" => 1,
          "error" => 2,
        }

        def initialize(dsl, opts)
          @dsl = dsl
          @opts = opts
          @text_layout = ::Swt::TextLayout.new Shoes.display
        end

        def paintControl(paint_event)
          gc = paint_event.gc
          gcs_reset gc
          @text_layout.setText @dsl.text
          set_styles
          if @dsl.width
            @text_layout.setWidth @dsl.width
            @text_layout.draw gc, @dsl.left.to_i + @dsl.margin_left, @dsl.top.to_i + @dsl.margin_top
            if @dsl.cursor
	      h = @text_layout.getLineBounds(0).height
              @dsl.textcursor ||= @dsl.app.line(0, 0, 0, h, strokewidth: 1, stroke: @dsl.app.black, hidden: true)
              n = @dsl.cursor == -1 ? @dsl.text.length - 1 : @dsl.cursor
              n = 0 if n < 0
              pos = @text_layout.getLocation n, true
              @dsl.textcursor.move(@dsl.left + pos.x, @dsl.top + pos.y).show
	    else
              (@dsl.textcursor.remove; @dsl.textcursor = nil) if @dsl.textcursor
	    end
          end
        end

        def set_styles
          @text_layout.setJustify @opts[:justify]
          @text_layout.setSpacing(@opts[:leading] || 4)
          @text_layout.setAlignment case @opts[:align]
            when 'center'; ::Swt::SWT::CENTER
            when 'right'; ::Swt::SWT::RIGHT
            else ::Swt::SWT::LEFT
            end
          font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size, ::Swt::SWT::NORMAL
          fgc = @opts[:stroke] ? ::Swt::Color.new(Shoes.display, @opts[:stroke].red, @opts[:stroke].green, @opts[:stroke].blue) : 
            ::Swt::Color.new(Shoes.display, 0, 0, 0)
          bgc = @opts[:fill] ? ::Swt::Color.new(Shoes.display, @opts[:fill].red, @opts[:fill].green, @opts[:fill].blue) : nil
          style = ::Swt::TextStyle.new font, fgc, bgc
          style.underline = @opts[:underline].nil? || @opts[:underline] == "none" ? false : true
          style.underlineStyle = UNDERLINE_STYLES[@opts[:underline]]
          @text_layout.setStyle style, 0, @dsl.text.length - 1
          @gcs << font << fgc << bgc

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
                cmds << "underline = true"
                fg = ::Swt::Color.new Shoes.display, 0, 0, 255
                spos = @text_layout.getLocation e[1].first, false
                epos = @text_layout.getLocation e[1].last, true
                left, top =  @dsl.left + @dsl.margin_left, @dsl.top + @dsl.margin_top
                e[0].lh = @text_layout.getLineBounds(0).height
                e[0].sx, e[0].sy = left + spos.x, top + spos.y
                e[0].ex, e[0].ey = left + epos.x, top + epos.y + e[0].lh
                e[0].pl, e[0].pt, e[0].pw, e[0].ph = left, top, @dsl.width, @dsl.height
                @dsl.links << e[0]
                unless e[0].clickabled
                  e[0].parent = @dsl
                  clickable e[0], e[0].blk
                  e[0].clickabled = true
                end
              else
              end
            end
            ft = ::Swt::Font.new Shoes.display, font, @dsl.font_size*small, ft
            style = ::Swt::TextStyle.new ft, fg, bg
            cmds.each{|cmd| eval "style.#{cmd}"}
            @text_layout.setStyle style, st[1].first, st[1].last
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
