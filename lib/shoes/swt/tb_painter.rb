class Shoes
  module Swt
    class TbPainter
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
        font = parse_font
        foreground_color = color_from_dsl @opts[:stroke], ::Swt::Color.new(Shoes.display, 0, 0, 0)
        background_color = color_from_dsl @opts[:fill]
        style = ::Swt::TextStyle.new font, foreground_color, background_color

        set_underline(style)
        set_undercolor(style)

        set_rise(style)

        set_strikethrough(style)
        set_strikecolor(style)

        @text_layout.setStyle style, 0, @dsl.text.length - 1
        @gcs << font << foreground_color << background_color

        set_text_styles(foreground_color, background_color)
      end

      private

      def create_link(e)
        spos = @text_layout.getLocation e[1].first, false
        epos = @text_layout.getLocation e[1].last, true
        left, top =  @dsl.left.to_i  + @dsl.margin_left, @dsl.top.to_i  + @dsl.margin_top
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
      end

      def nested_styles styles, st
        styles.map do |e|
          (e[1].first <= st[1].first and st[1].last <= e[1].last) ? e : nil
        end - [nil]
      end

      def set_text_styles(fgc, bgc)
        @opts[:text_styles].each do |st|
          font, ft, fg, bg, cmds, small = @dsl.font, ::Swt::SWT::NORMAL, fgc, bgc, [], 1
          nested_styles(@opts[:text_styles], st).each do |e|
            case e[0].style
              when :strong
                ft = ft | ::Swt::SWT::BOLD
              when :em
                ft = ft | ::Swt::SWT::ITALIC
              when :fg
                fg = color_from_dsl e[0]
              when :bg
                bg = color_from_dsl e[0]
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
                create_link(e)
              else
            end
          end
          ft = ::Swt::Font.new Shoes.display, font, @dsl.font_size*small, ft
          style = ::Swt::TextStyle.new ft, fg, bg
          cmds.each{|cmd| eval "style.#{cmd}"}
          set_strikecolor(style)
          set_undercolor(style)
          @text_layout.setStyle style, st[1].first, st[1].last
          @gcs << ft
        end if @opts[:text_styles]
      end

      def parse_font
        font_style = 0
        font_style |= ::Swt::SWT::BOLD if @opts[:weight]
        font_style |= ::Swt::SWT::ITALIC if @opts[:emphasis]
        font_style |= ::Swt::SWT::NORMAL if !@opts[:weight] && !@opts[:emphasis]

        ::Swt::Font.new(Shoes.display, @dsl.font, @dsl.font_size, font_style)
      end

      def set_rise(style)
        style.rise = @opts[:rise]
      end

      def set_underline(style)
        style.underline = @opts[:underline].nil? || @opts[:underline] == "none" ? false : true
        style.underlineStyle = UNDERLINE_STYLES[@opts[:underline]]
      end

      def set_undercolor(style)
        style.underlineColor = color_from_dsl @opts[:undercolor]
      end

      def set_strikethrough(style)
        style.strikeout = @opts[:strikethrough].nil? || @opts[:strikethrough] == "none" ? false : true
      end

      def set_strikecolor(style)
        style.strikeoutColor = color_from_dsl @opts[:strikecolor]
      end

      def color_from_dsl dsl_color, default = nil
        return default if dsl_color.nil?
        ::Swt::Color.new(Shoes.display, dsl_color.red, dsl_color.green, dsl_color.blue)
      end
    end
  end
end
