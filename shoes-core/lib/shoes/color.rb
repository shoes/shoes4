class Shoes
  class Color
    include Common::Inspect
    include Comparable

    OPAQUE = 255
    TRANSPARENT = 0

    def self.create(color)
      color.is_a?(Color) ? color : new(color)
    end

    def initialize(*args) # red, green, blue, alpha = OPAQUE)
      case args.length
      when 1
        red, green, blue, alpha = HexConverter.new(args.first).to_rgb
      when 3, 4
        red, green, blue, alpha = *args
      else
        message = <<EOS
Wrong number of arguments (#{args.length} for 1, 3, or 4).
Must be one of:
  - #{self.class}.new(hex_string)
  - #{self.class}.new(red, green, blue)
  - #{self.class}.new(red, green, blue, alpha)
EOS
        fail ArgumentError, message
      end
      alpha ||= OPAQUE
      @red = normalize_rgb(red)
      @green = normalize_rgb(green)
      @blue = normalize_rgb(blue)
      @alpha = normalize_rgb(alpha)
    end

    attr_reader :red, :green, :blue, :alpha

    def light?
      @red + @green + @blue > 510 # 0xaa * 3
    end

    def dark?
      @red + @green + @blue < 255 # 0x55 * 3
    end

    def transparent?
      @alpha == TRANSPARENT
    end

    def opaque?
      @alpha == OPAQUE
    end

    def white?
      @red == 255 && @green == 255 && @blue == 255
    end

    def black?
      @red == 0 && @green == 0 && @blue == 0
    end

    def <=>(other)
      raise_class_mismatch_error(other) unless other.is_a?(self.class)
      if same_base_color?(other)
        @alpha <=> other.alpha
      else
        less_or_greater_than other
      end
    end

    # @return [String] a hex represenation of this color
    # @example
    #   Shoes::Color.new(255, 0, 255).hex # => "#ff00ff"
    def hex
      format "#%02x%02x%02x", @red, @green, @blue
    end

    def to_s
      "rgb(#{red}, #{green}, #{blue})"
    end

    private

    def inspect_details
      " #{self} alpha:#{@alpha}"
    end

    def normalize_rgb(value)
      rgb = value.is_a?(Fixnum) ? value : (255 * value).round
      return 255 if rgb > 255
      return 0 if rgb < 0
      rgb
    end

    def raise_class_mismatch_error(other)
      fail ArgumentError,
           "can't compare #{self.class.name} with #{other.class.name}"
    end

    def same_base_color?(other)
      @red == other.red && @green == other.green && @blue == other.blue
    end

    def less_or_greater_than(other)
      own_sum   = @red + @green + @blue
      other_sum = other.red + other.green + other.blue
      if own_sum > other_sum
        1
      else
        -1
      end
    end

    class HexConverter
      def initialize(hex)
        @hex = validate(hex) || fail(ArgumentError, "Bad hex color: #{hex}")
        @red, @green, @blue = hex_to_rgb(pad_if_necessary @hex)
      end

      def to_rgb
        [@red, @green, @blue]
      end

      private

      def hex_to_rgb(hex)
        hex.chars.each_slice(2).map { |a| a.join.to_i(16) }
      end

      def pad_if_necessary(hex)
        return hex unless hex.length == 3
        hex.chars.map { |c| "#{c}#{c}" }.join
      end

      # Returns a 3- or 6-char hex string for valid input, or nil
      # for invalid input.
      def validate(hex)
        match = /^#?(([0-9a-f]{3}){1,2})$/i.match(hex)
        match && match[1]
      end
    end

    module DSLHelpers
      def pattern(*args)
        if args.length == 1
          arg = args.first
          case arg
          when String
            image_file?(arg) ? image_pattern(arg) : color(arg)
          when Shoes::Color
            color arg
          when Range, Shoes::Gradient
            gradient(arg)
          when Shoes::ImagePattern
            arg
          else
            fail ArgumentError, "Bad pattern: #{arg.inspect}"
          end
        else
          gradient(*args)
        end
      end

      def color(arg)
        Shoes::Color.create(arg)
      end

      def rgb(red, green, blue, alpha = Shoes::Color::OPAQUE)
        Shoes::Color.new(red, green, blue, alpha)
      end

      # Creates a new Shoes::Gradient
      #
      # @overload gradient(from, to)
      #   @param [Shoes::Color] from the starting color
      #   @param [Shoes::Color] to the ending color
      #
      # @overload gradient(from, to)
      #   @param [String] from a hex string representing the starting color
      #   @param [String] to a hex string representing the ending color
      #
      # @overload gradient(range)
      #   @param [Range<Shoes::Color>] range min color to max color
      #
      # @overload gradient(range)
      #   @param [Range<String>] range min color to max color
      def gradient(*args)
        case args.length
        when 1
          arg = args[0]
          case arg
          when Gradient
            min, max = arg.color1, arg.color2
          when Range
            min, max = arg.first, arg.last
          else
            fail ArgumentError, "Can't make gradient out of #{arg.inspect}"
          end
        when 2
          min, max = args[0], args[1]
        else
          fail ArgumentError, "Wrong number of arguments (#{args.length} for 1 or 2)"
        end
        Shoes::Gradient.new(color(min), color(max))
      end

      def gray(level = 128, alpha = Shoes::Color::OPAQUE)
        Shoes::Color.new(level, level, level, alpha)
      end

      alias_method :grey, :gray

      private

      def image_file?(arg)
        arg =~ /\.gif|jpg|jpeg|png$/
      end

      def image_pattern(path)
        Shoes::ImagePattern.new path if File.exist?(path)
      end
    end
  end

  # Create all of the built-in Shoes colors
  COLORS = {}

  module DSL
    colors = [
      [:aliceblue, 240, 248, 255],
      [:antiquewhite, 250, 235, 215],
      [:aqua, 0, 255, 255],
      [:aquamarine, 127, 255, 212],
      [:azure, 240, 255, 255],
      [:beige, 245, 245, 220],
      [:bisque, 255, 228, 196],
      [:black, 0, 0, 0],
      [:blanchedalmond, 255, 235, 205],
      [:blue, 0, 0, 255],
      [:blueviolet, 138, 43, 226],
      [:brown, 165, 42, 42],
      [:burlywood, 222, 184, 135],
      [:cadetblue, 95, 158, 160],
      [:chartreuse, 127, 255, 0],
      [:chocolate, 210, 105, 30],
      [:coral, 255, 127, 80],
      [:cornflowerblue, 100, 149, 237],
      [:cornsilk, 255, 248, 220],
      [:crimson, 220, 20, 60],
      [:cyan, 0, 255, 255],
      [:darkblue, 0, 0, 139],
      [:darkcyan, 0, 139, 139],
      [:darkgoldenrod, 184, 134, 11],
      [:darkgray, 169, 169, 169],
      [:darkgrey, 169, 169, 169],
      [:darkgreen, 0, 100, 0],
      [:darkkhaki, 189, 183, 107],
      [:darkmagenta, 139, 0, 139],
      [:darkolivegreen, 85, 107, 47],
      [:darkorange, 255, 140, 0],
      [:darkorchid, 153, 50, 204],
      [:darkred, 139, 0, 0],
      [:darksalmon, 233, 150, 122],
      [:darkseagreen, 143, 188, 143],
      [:darkslateblue, 72, 61, 139],
      [:darkslategray, 47, 79, 79],
      [:darkslategrey, 47, 79, 79],
      [:darkturquoise, 0, 206, 209],
      [:darkviolet, 148, 0, 211],
      [:deeppink, 255, 20, 147],
      [:deepskyblue, 0, 191, 255],
      [:dimgray, 105, 105, 105],
      [:dimgrey, 105, 105, 105],
      [:dodgerblue, 30, 144, 255],
      [:firebrick, 178, 34, 34],
      [:floralwhite, 255, 250, 240],
      [:forestgreen, 34, 139, 34],
      [:fuchsia, 255, 0, 255],
      [:gainsboro, 220, 220, 220],
      [:ghostwhite, 248, 248, 255],
      [:gold, 255, 215, 0],
      [:goldenrod, 218, 165, 32],
      [:green, 0, 128, 0],
      [:greenyellow, 173, 255, 47],
      [:honeydew, 240, 255, 240],
      [:hotpink, 255, 105, 180],
      [:indianred, 205, 92, 92],
      [:indigo, 75, 0, 130],
      [:ivory, 255, 255, 240],
      [:khaki, 240, 230, 140],
      [:lavender, 230, 230, 250],
      [:lavenderblush, 255, 240, 245],
      [:lawngreen, 124, 252, 0],
      [:lemonchiffon, 255, 250, 205],
      [:lightblue, 173, 216, 230],
      [:lightcoral, 240, 128, 128],
      [:lightcyan, 224, 255, 255],
      [:lightgoldenrodyellow, 250, 250, 210],
      [:lightgreen, 144, 238, 144],
      [:lightgray, 211, 211, 211],
      [:lightgrey, 211, 211, 211],
      [:lightpink, 255, 182, 193],
      [:lightsalmon, 255, 160, 122],
      [:lightseagreen, 32, 178, 170],
      [:lightskyblue, 135, 206, 250],
      [:lightslategray, 119, 136, 153],
      [:lightslategrey, 119, 136, 153],
      [:lightsteelblue, 176, 196, 222],
      [:lightyellow, 255, 255, 224],
      [:lime, 0, 255, 0],
      [:limegreen, 50, 205, 50],
      [:linen, 250, 240, 230],
      [:magenta, 255, 0, 255],
      [:maroon, 128, 0, 0],
      [:mediumaquamarine, 102, 205, 170],
      [:mediumblue, 0, 0, 205],
      [:mediumorchid, 186, 85, 211],
      [:mediumpurple, 147, 112, 219],
      [:mediumseagreen, 60, 179, 113],
      [:mediumslateblue, 123, 104, 238],
      [:mediumspringgreen, 0, 250, 154],
      [:mediumturquoise, 72, 209, 204],
      [:mediumvioletred, 199, 21, 133],
      [:midnightblue, 25, 25, 112],
      [:mintcream, 245, 255, 250],
      [:mistyrose, 255, 228, 225],
      [:moccasin, 255, 228, 181],
      [:navajowhite, 255, 222, 173],
      [:navy, 0, 0, 128],
      [:oldlace, 253, 245, 230],
      [:olive, 128, 128, 0],
      [:olivedrab, 107, 142, 35],
      [:orange, 255, 165, 0],
      [:orangered, 255, 69, 0],
      [:orchid, 218, 112, 214],
      [:palegoldenrod, 238, 232, 170],
      [:palegreen, 152, 251, 152],
      [:paleturquoise, 175, 238, 238],
      [:palevioletred, 219, 112, 147],
      [:papayawhip, 255, 239, 213],
      [:peachpuff, 255, 218, 185],
      [:peru, 205, 133, 63],
      [:pink, 255, 192, 203],
      [:plum, 221, 160, 221],
      [:powderblue, 176, 224, 230],
      [:purple, 128, 0, 128],
      [:red, 255, 0, 0],
      [:rosybrown, 188, 143, 143],
      [:royalblue, 65, 105, 225],
      [:saddlebrown, 139, 69, 19],
      [:salmon, 250, 128, 114],
      [:sandybrown, 244, 164, 96],
      [:seagreen, 46, 139, 87],
      [:seashell, 255, 245, 238],
      [:sienna, 160, 82, 45],
      [:silver, 192, 192, 192],
      [:skyblue, 135, 206, 235],
      [:slateblue, 106, 90, 205],
      [:slategray, 112, 128, 144],
      [:slategrey, 112, 128, 144],
      [:snow, 255, 250, 250],
      [:springgreen, 0, 255, 127],
      [:steelblue, 70, 130, 180],
      [:tan, 210, 180, 140],
      [:teal, 0, 128, 128],
      [:thistle, 216, 191, 216],
      [:tomato, 255, 99, 71],
      [:turquoise, 64, 224, 208],
      [:violet, 238, 130, 238],
      [:wheat, 245, 222, 179],
      [:white, 255, 255, 255],
      [:whitesmoke, 245, 245, 245],
      [:yellow, 255, 255, 0],
      [:yellowgreen, 154, 205, 50],
      [:shoes_background, 237, 237, 237],
    ]

    colors.each do |color_name, r, g, b|
      Shoes::COLORS[color_name] = Shoes::Color.new(r, g, b)
      define_method(color_name) do |alpha = Shoes::Color::OPAQUE|
        color = Shoes::COLORS.fetch(color_name)
        return color if alpha == Shoes::Color::OPAQUE
        Shoes::Color.new(color.red, color.green, color.blue, alpha)
      end
    end
  end
end
