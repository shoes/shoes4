# frozen_string_literal: true
class Shoes
  module Swt
    class Progress
      include Common::Remove
      include Common::Visibility
      include Common::UpdatePosition
      include DisposedProtection
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :app, :dsl

      def initialize(dsl, app)
        @dsl = dsl
        @app = app

        @real = ::Swt::Widgets::ProgressBar.new(@app.real,
                                                ::Swt::SWT::SMOOTH)
        real.minimum = 0
        real.maximum = 100

        if @dsl.element_width && @dsl.element_height
          real.setSize dsl.element_width, dsl.element_height
        else
          real.pack
          @dsl.element_width  = real.size.x
          @dsl.element_height = real.size.y
        end
      end

      def fraction=(value)
        real.selection = (value * 100).to_i
      end
    end
  end
end
