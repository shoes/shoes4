
module Shoes
  class Layout
    include Shoes::ElementMethods

    # Descendant classes should configure their own instance
    # of Java Swing JPanel, which is exposed to the
    # &blk as 'container'.  The Layout's own 'container'
    # is held as 'parent_container' for any future use of the Layout
    # itself.
    # super(parent_container) must be called *after* the Layout instance
    # has setup its own @container
    def initialize(parent_container, opts={}, &blk)

    end
    #
    #def flow(opts = {}, &blk)
    #  swt_flow = Shoes::Flow.new container, opts, &blk
    #end
    #
    #
    #def button(text, opts={}, &blk)
    #  button = Shoes::Button.new(container, text, opts, &blk)
    #  #@elements[button.to_s] = button
    #  #button
    #end


  end
end
