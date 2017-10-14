# frozen_string_literal: true

class Shoes
  module DSL
    module Media
      def image(*args, &blk)
        if blk
          raise Shoes::NotImplementedError,
                'Sorry image does not support the block form in Shoes 4!' \
                ' Check out github issue #1309 for any changes/updates or if you' \
                ' want to help :)'
        else
          opts = style_normalizer.normalize pop_style(args)
          path, *leftovers = args

          message = <<EOS
Wrong number of arguments. Must be:
  - image(path, [opts])
EOS
          raise ArgumentError, message if leftovers.any?

          create Shoes::Image, path, opts
        end
      end

      def video(*_args)
        raise Shoes::NotImplementedError,
              'Sorry video support has been cut from shoes 4!' \
              ' Check out github issue #113 for any changes/updates or if you' \
              ' want to help :)'
      end

      # similar controls as Shoes::Video (#video)
      def sound(soundfile, opts = {}, &blk)
        Shoes::Sound.new @__app__, soundfile, opts, &blk
      end
    end
  end
end
