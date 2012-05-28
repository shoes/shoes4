module SwtShoes
  # Shape methods
  #
  # Including classes must provide:
  #
  # @x          - the current x-value
  # @y          - the current y-value
  # @opts       - options
  #
  module Shape
    attr_reader :gui_container, :gui_element
    attr_reader :gui_paint_callback

    # The initialization hook for SwtShoes.
    #
    # Swt calls to Shoes::Shape#new should include in the style hash
    # a :gui key that contains Swt-specific settings.
    #
    # Example:
    #
    #   args[:top] = 100
    #   args[:width] = 80
    #   args[:gui] = {
    #     container: self.gui_container,
    #     paint_callback: lambda do |event, shape|
    #       gc = event.gc
    #       gc.set_antialias Swt::SWT::ON
    #       gc.set_line_width 1
    #       gc.draw_oval(shape.left, shape.top, shape.width, shape.height)
    #     end
    #   }
    #
    #   This hook method is only interested in the `:gui` values, which will
    #   be passed in the @gui_opts variable.
    #
    #   Note in particular the `:paint_callback`. It has 2 parameters. The
    #   first is the Swt event that will trigger the callback. The second is
    #   this shape.
    def gui_init
      # @gui_opts must be provided if this shape is responsible for
      # drawing itself. If this shape is part of another shape, then
      # @gui_opts should be nil
      if @gui_opts
        @gui_container = @gui_opts[:container]
        @gui_element = @gui_opts[:element] || Swt::Path.new(Swt.display)
        #@transform.translate(-130, -100)
        @gui_paint_callback = lambda do |event|
          gc = event.gc
          @transform = Swt::Transform.new(Swt.display) unless @transform
          gc.setTransform(@transform)
          gc.set_background self.fill.to_native
          gc.fill_path(@gui_element)
          gc.set_antialias Swt::SWT::ON
          gc.set_foreground self.stroke.to_native
          gc.set_line_width self.style[:strokewidth]
          gc.draw_path(@gui_element)
          @transform.dispose
        end
        @gui_container.add_paint_listener(@gui_paint_callback)
      end
    end

    def line_to(x, y)
      @components << ::Shoes::Line.new(@x, @y, x, y, @style)
      @gui_element.line_to(x, y)
    end

    def move_to(x, y)
      @x, @y = x, y
      @gui_element.move_to(x, y)
    end

    def move(left, top)
      super left, top
      @transform = Swt::Transform.new(Swt.display)
      @transform.translate(self.left, self.top)
    end
  end
end

module Shoes
  class Shape
    # This is a hack to allow methods in this class to override methods
    # defined in Shoes::Shape. It would be better fixed by a different
    # architecture. The self.extend doesn't work if the module has already
    # been included by the class.
    #include SwtShoes::Shape
    alias :old_initialize :initialize
    def initialize(opts = {}, blk = nil)
      self.extend SwtShoes::Shape
      old_initialize opts, blk
    end
  end
end
