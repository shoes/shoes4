require 'shoes/common_methods'

module Shoes
  DEFAULT_TEXTBLOCK_FONT = ["Arial"]

  class TextBlock
    include Shoes::CommonMethods

    attr_reader  :gui, :blk, :parent, :text
    attr_accessor :font_size
    alias_method :to_s, :text
    alias_method :contents, :text

    def initialize(parent, text="", font_size=5, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @app = opts[:app]
      @font_size = font_size
      @text = text

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
      handle_opts opts
      @parent.add_child self
    end

    def font_size=(size)
      @font_size = size
      @gui.set_font unless @gui.nil?
    end

    def text=(string)
      @text = string
      @gui.update_text
    end

    def replace(string)
      self.text = string
    end

    def font_size_no_update=(size)
      @font_size = size
    end

    private

    # Takes the form "[FAMILY-LIST] [STYLE-OPTIONS] [SIZE]"
    # where FAMILY-LIST is a comma separated list of
    # families optionally terminated by a comma,
    # STYLE_OPTIONS is a whitespace separated list of words
    # where each WORD describes one of style, variant,
    # weight, stretch, or gravity, and SIZE is a decimal
    # number (size in points) or optionally followed by the
    # unit modifier "px" for absolute size. Any one of the
    # options may be absent. If FAMILY-LIST is absent, then
    # the default font family (Arial) will be used.

    # font_family only specifies what value it should
    # default to, if a font family isn't specified in
    # the string type
    def set_font(type, style_only=false)
      fsize_regex = /\d+(?=px)?/
      style_regex = /none|bold|normal|oblique|italic/i # TODO: Add more
      ffamily = type.gsub(style_regex,'').gsub(/\d+(px)?/,'').split(',').
        map { |x| x.strip.gsub(/["]/,'') }

      unless style_only
        font_family = DEFAULT_TEXTBLOCK_FONT
        font_family = ffamily unless (ffamily.size == 1 and ffamily[0] == "") or ffamily.size == 0
        font_size = type.scan(fsize_regex).first.to_i unless type.scan(fsize_regex).empty?
      end
      style_options = type.scan(style_regex).map { |x| x.to_sym }

      p "shose.."
      @gui.set_font font_family, style_options, font_size
    end

    # TODO: Remove most of these (the unused ones)
    def handle_opts(opts)
      @opts = opts
      if opts.has_key? :click
        # TODO!
      elsif opts.has_key? :emphasis
        set_font opts[:emphasis], true
      elsif opts.has_key? :family
        set_font opts[:family]
      elsif opts.has_key? :font
        set_font opts[:font]
      elsif opts.has_key? :variant
        case opts[:variant]
        when "normal"
          # set it to normal
        when "smallcaps"
          # not sure how this is done under swt
        end
      elsif opts.has_key? :hidden
        @gui.hidden opts[:hidden]
      elsif opts.has_key? :leading
        # need to look up if this is possible
        # with styledtext
      elsif opts.has_key? :rise
        # not sure what this does. need to
        # look it up.
      elsif opts.has_key? :stretch
        # not sure how to implement this

      # I think that the following styles
      # have to be done by "manually" painting
      # on the object. It is currently impossible
      # to do since we haven't decided on how
      # the layouter(s) are going to function
      # in all cases.
      elsif opts.has_key? :fill
        # NOTE: Not possible at the moment, since it's
        # according to the manual "painted as with a"
        # highlight pen
        # perhaps paint it manually? how? layout issues
      elsif opts.has_key? :strikecolor
        # not sure how to do. can just draw on it
        # I guess
      elsif opts.has_key? :strikethrough
        case opts[:strikethrough]
        when "none"
          puts "not strikken trough"
        when "single"
          puts "strike through"
        end
      elsif opts.has_key? :stroke
        puts "set color"
      elsif opts.has_key? :undercolor
        # not sure how to do this. same as for
        # strike color
      elsif opts.has_key? :underline
        case opts[:underline]
        when "none"
          puts "not underlined"
        when "single"
          puts "single underline"
        when "double"
          puts "double underline"
        when "low"
          # not sure what this is
        when "error"
        end
      elsif opts.has_key? :wrap
        # think this is related to layouts
      end
    end
  end
end
