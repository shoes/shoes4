# frozen_string_literal: true
class Shoes
  class Color
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
            raise ArgumentError, "Bad pattern: #{arg.inspect}"
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
            min = arg.color1
            max = arg.color2
          when Range
            min = arg.first
            max = arg.last
          else
            raise ArgumentError, "Can't make gradient out of #{arg.inspect}"
          end
        when 2
          min = args[0]
          max = args[1]
        else
          raise ArgumentError, "Wrong number of arguments (#{args.length} for 1 or 2)"
        end
        Shoes::Gradient.new(color(min), color(max))
      end

      def gray(level = 128, alpha = Shoes::Color::OPAQUE)
        Shoes::Color.new(level, level, level, alpha)
      end

      alias grey gray

      private

      def image_file?(arg)
        arg =~ /\.gif|jpg|jpeg|png$/
      end

      def image_pattern(path)
        Shoes::ImagePattern.new path if File.exist?(path)
      end
    end
  end
end
