#require 'shoes/framework_adapters/swt_shoes/element_methods'

module SwtShoes
    class Layout

      DEFAULT_WIDTH = 800
      DEFAULT_HEIGHT = 600
      DEFAULT_TITLE = "Shooes!"


      #include SwtShoes::ElementMethods
      include Log4jruby::LoggerForClass

      # default initializer for calls to
      # super() from descendant classes
      def initialize(composite_parent, opts = {}, &blk)
        @container = Swt::Widgets::Composite.new(composite_parent, Swt::SWT::NONE || Swt::SWT::BORDER)

        width, height = opts['width'] || DEFAULT_WIDTH, opts['height'] || DEFAULT_HEIGHT

        # RowLayout is horizontal by default, wrapping by default
        @layout = Swt::Layout::RowLayout.new

        @layout.type = opts['layout_type'] if opts['layout_type']

        # set the margins
        set_layout_margins(opts[:margin]) if opts[:margin]

        if width && height
          #@border = Swt::Widgets::Composite.new(composite_parent, Swt::SWT::BORDER)
          #debugger
          @container.setSize(width, height)
        end

        @container.setLayout(@layout)

        instance_eval &blk if block_given?

        @container.pack unless width && height

      end

      # Add this many pixels to margins on layout
      def set_layout_margins(margin_pixels)
        @layout.marginTop = margin_pixels
        @layout.marginRight = margin_pixels
        @layout.marginBottom = margin_pixels
        @layout.marginLeft = margin_pixels
      end


      #
      #def layout(layer, &blk)
      #  parent = @current_panel
      #  @current_panel = layer.panel
      #  instance_eval &blk
      #  parent.add(@current_panel)
      #  @current_panel = parent
      #end


    end
end
