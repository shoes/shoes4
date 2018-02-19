# frozen_string_literal: true

class Shoes
  module DSL
    # DSL methods for handling media
    #
    # @see Shoes::DSL
    module Media
      # Previously supported method for drawing an image. Very similar to
      # shape. See https://github.com/shoes/shoes4/issues/1309 for details.
      #
      # @deprecated
      def image(*args, &blk)
        if blk
          raise Shoes::NotImplementedError,
                'Sorry image does not support the block form in Shoes 4!' \
                ' Check out github issue #1309 for any changes/updates or if you' \
                ' want to help :)'
        else
          opts = style_normalizer.normalize pop_style(args)
          path, *leftovers = args

          message = <<~EOS
            Wrong number of arguments. Must be:
              - image(path, [opts])
EOS
          raise ArgumentError, message if leftovers.any?

          create Shoes::Image, path, opts
        end
      end

      # Previously supported method for showing video. Cut because codecs.
      # See https://github.com/shoes/shoes4/issues/113 for details.
      #
      # @deprecated
      def video(*_args)
        raise Shoes::NotImplementedError,
              'Sorry video support has been cut from shoes 4!' \
              ' Check out github issue #113 for any changes/updates or if you' \
              ' want to help :)'
      end

      # Play a sound from supported file formats.
      #
      # Supported formats:
      #
      #  * aiff
      #  * mp3
      #  * ogg/vorbis
      #  * wav
      #
      # @param [String] soundfile location of sound to play
      # @param [Hash] opts none currently supported
      # @return [Shoes::Sound]
      def sound(soundfile, opts = {}, &blk)
        Shoes::Sound.new @__app__, soundfile, opts, &blk
      end
    end
  end
end
