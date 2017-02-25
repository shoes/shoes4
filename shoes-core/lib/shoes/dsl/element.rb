# frozen_string_literal: true
class Shoes
  module DSL
    module Element
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

      def border(color, styles = {})
        create Shoes::Border, pattern(color), styles
      end

      def background(color, styles = {})
        create Shoes::Background, pattern(color), style_normalizer.normalize(styles)
      end

      def edit_line(*args, &blk)
        style = pop_style(args)
        text  = args.first || ''
        create Shoes::EditLine, text, style, blk
      end

      def edit_box(*args, &blk)
        style = pop_style(args)
        text  = args.first || ''
        create Shoes::EditBox, text, style, blk
      end

      def progress(opts = {}, &blk)
        create Shoes::Progress, opts, blk
      end

      def check(opts = {}, &blk)
        create Shoes::Check, opts, blk
      end

      def radio(*args, &blk)
        style = pop_style(args)
        group = args.first
        create Shoes::Radio, group, style, blk
      end

      def list_box(opts = {}, &blk)
        create Shoes::ListBox, opts, blk
      end

      def flow(opts = {}, &blk)
        create Shoes::Flow, opts, blk
      end

      def stack(opts = {}, &blk)
        create Shoes::Stack, opts, blk
      end

      def button(text = nil, opts = {}, &blk)
        create Shoes::Button, text, opts, blk
      end
    end
  end
end
