require 'shoes/common_methods'

module Shoes
  class Text_block
    include Shoes::CommonMethods

    # TODO: need to provide @style (element_methods)


    attr_accessor :gui_container, :gui_element
    attr_reader :text, :font_size
    alias_method :to_s, :text
    alias_method :contents, :text

    def initialize(gui_container, text, font_size, opts={})
      self.gui_container = gui_container

      @text = text
      @font_size = font_size

      gui_textblock_init
    end

    def text=(string)
      @text = string
      gui_update_text
    end

    def replace(string)
      self.text = string
    end
  end

  # Text block types
  # I was thinking about just accepting different font_sizes
  # and using Text_blocks in element_methods.rb, but this
  # is a bit easier to test and it's more obvious where
  # the font sizes are specified
  class Banner < Text_block
    def initialize(gui_container, text, opts={})
      super(gui_container, text, 48, opts)
    end
  end

  class Title < Text_block
    def initialize(gui_container, text, opts)
      super gui_container, text, 34, opts
    end
  end

  class Subtitle < Text_block
    def initialize(gui_container, text, opts)
      super gui_container, text, 26, opts
    end
  end

  class Tagline < Text_block
    def initialize(gui_container, text, opts)
      super gui_container, text, 18, opts
    end
  end

  class Caption < Text_block
    def initialize(gui_container, text, opts)
      super gui_container, text, 14, opts
    end
  end

  class Para < Text_block
    def initialize(gui_container, text, opts)
      super gui_container, text, 12, opts
    end
  end

  class Inscription < Text_block
    def initialize(gui_container, text, opts)
      super gui_container, text, 10, opts
    end
  end
end
