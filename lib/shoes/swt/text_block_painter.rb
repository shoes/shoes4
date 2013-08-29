class Shoes
  module Swt
    class TextBlockPainter
      include ::Swt::Events::PaintListener
      include Common::Resource
      include Common::Clickable

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
        style = apply_styles(default_text_styles(nil, nil, @opts[:strikecolor], @opts[:undercolor]), @opts)
        set_text_style(@text_layout, style, 0..(@dsl.text.length - 1))
        set_text_styles(style[:fg], style[:bg], @text_layout, @opts)
      end

      private

      def apply_styles(styles, opts)
        styles[:font][:styles] = parse_font_style(opts)
        styles[:fg] = opts[:stroke]
        styles[:bg] = opts[:fill]
        styles.merge(opts)
      end

      def create_link(e)
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
      end

      def set_text_styles(foreground, background, layout, opts)
        opts[:text_styles].each do |range, text_styles|
          defaults = default_text_styles(foreground, background, opts[:strikecolor], opts[:undercolor])
          styles = text_styles.inject(defaults) do |current_styles, text|
            if text.style == :span
              apply_styles(current_styles, text.opts)
            else
              accumulate_text_styles(text, current_styles)
            end
          end
          set_text_style(layout, styles, range)
        end if opts[:text_styles]
      end

      def set_text_style(layout, styles, range)
        f = styles[:font]
        font = create_font f[:name], f[:size], f[:styles]
        style = create_style font, styles[:fg], styles[:bg], styles
        layout.setStyle style, range.first, range.last
      end

      def default_text_styles(foreground, background, strikecolor, undercolor)
        {
          :fg          => foreground,
          :bg          => background,
          :strikecolor => strikecolor,
          :undercolor  => undercolor,
          :font        => {
            :name   => @dsl.font,
            :size   => @dsl.font_size,
            :styles => [::Swt::SWT::NORMAL]
          }
        }
      end

      def accumulate_text_styles(text, styles)
        case text.style
        when :strong
          styles[:font][:styles] << ::Swt::SWT::BOLD
        when :em
          styles[:font][:styles] << ::Swt::SWT::ITALIC
        when :fg
          styles[:fg] = text.color
        when :bg
          styles[:bg] = text.color
        when :ins
          styles[:underline] = true
        when :del
          styles[:strikeout] = true
        when :sub
          styles[:font][:size] *= 0.8
          styles[:rise] = -5
        when :sup
          styles[:font][:size] *= 0.8
          styles[:rise] = 5
        when :code
          styles[:font][:name] = "Lucida Console"
        when :link
          styles[:underline] = true
          styles[:fg] = ::Swt::Color.new Shoes.display, 0, 0, 255
          create_link(text)
        else
        end
        styles
      end

      def parse_font_style(opts)
        font_styles = []
        font_styles << ::Swt::SWT::BOLD if opts[:weight]
        font_styles << ::Swt::SWT::ITALIC if opts[:emphasis]
        font_styles << ::Swt::SWT::NORMAL if !opts[:weight] && !opts[:emphasis]
        font_styles
      end

      def create_font(name, size, styles)
        #TODO: mark font for garbage collection
        ::Swt::Font.new Shoes.display, name, size, styles.reduce { |result, s| result | s }
      end

      def create_style(font, foreground, background, opts)
        TextStyleFactory.new(font, foreground, background, opts).style
      end
    end

    class TextStyleFactory
      UNDERLINE_STYLES = {
          "single" => 0,
          "double" => 1,
          "error" => 2,
      }

      def initialize(font, foreground, background, opts)
        fg = swt_color(foreground, ::Shoes::COLORS[:black])
        bg = swt_color(background)
        @style = ::Swt::TextStyle.new font, fg, bg
        set_underline(@style, opts)
        set_undercolor(@style, opts)
        set_rise(@style, opts)
        set_strikethrough(@style, opts)
        set_strikecolor(@style, opts)
      end

      attr_reader :style

      private
      def set_rise(style, opts)
        style.rise = opts[:rise]
      end

      def set_underline(style, opts)
        style.underline = opts[:underline].nil? || opts[:underline] == "none" ? false : true
        style.underlineStyle = UNDERLINE_STYLES[opts[:underline]]
      end

      def set_undercolor(style, opts)
        style.underlineColor = color_from_dsl opts[:undercolor]
      end

      def set_strikethrough(style, opts)
        style.strikeout = opts[:strikethrough].nil? || opts[:strikethrough] == "none" ? false : true
      end

      def set_strikecolor(style, opts)
        style.strikeoutColor = color_from_dsl opts[:strikecolor]
      end

      def swt_color(color, default = nil)
        return color if color.is_a? ::Swt::Color
        color_from_dsl color, default
      end

      def color_from_dsl(dsl_color, default = nil)
        return nil if dsl_color.nil? and default.nil?
        return color_from_dsl default if dsl_color.nil?
        # TODO: mark color for garbage collection
        ::Swt::Color.new(Shoes.display, dsl_color.red, dsl_color.green, dsl_color.blue)
      end
    end
  end
end
