module Shoes
  module Swt
    module ElementMethods

      #def stack(opts={}, &blk)
      #  tstack = Stack.new(opts)
      #  layout(tstack, &blk)
      #end

      #def flow(opts = {}, &blk)
      #  swt_flow = Shoes::Swt::Shoes::Flow.new(container, opts, &blk)
      #end

      #
      #def button(text, opts={}, &blk)
      #  button = Shoes::Button.new(container, text, opts, &blk)
      #  #@elements[button.to_s] = button
      #  #button
      #end
      #
      #def animate(fps = 10, &blk)
      #  anim = Shoes::Animation.new(fps, &blk)
      #end

      #
      #def image(path, opts={})
      #  image = Image.new(path, @current_panel, opts)
      #  @elements[image.identifier] = image
      #  image
      #end
      #
      #def edit_line(opts={})
      #  eline = Edit_line.new(@current_panel, opts)
      #  @elements[eline.identifier] = eline
      #  eline
      #end
      #
      #def text_box(opts={})
      #  tbox = Text_box.new(@current_panel, opts)
      #  @elements[tbox.identifier] = tbox
      #  tbox
      #end
      #
      #def check(opts={}, &blk)
      #  cbox = Check.new(@current_panel, opts)
      #  @elements[cbox.identifier] = cbox
      #  cbox
      #end
      #
      def line(*opts)
        args = opts.last.class == Hash ? opts.pop : {}
        args[:gui] = {container: self.gui}
        super(*opts, args)
      end

      # FIXME: same as #line
      def shape(*opts)
        args = opts.last.class == Hash ? opts.pop : {}
        args[:gui] = {container: self.gui}
        super(*opts, args)
      end
    end
  end
end

module Shoes
  class App
    include Shoes::Swt::ElementMethods
  end
end
