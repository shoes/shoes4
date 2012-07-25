module Shoes
  module Swt
    class Image
      include Common::Child

      attr_reader :parent

      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk

        @real = ::Swt::Graphics::Image.new(::Swt.display, @dsl.file_path)
        @label = ::Swt::Widgets::Label.new(@parent.real,
                                           ::Swt::SWT::NONE)
        @label.image = @real
        @label.pack # remove this after pack bug has been fixed
      end
    end
  end
end
