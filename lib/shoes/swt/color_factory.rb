class Shoes
  module Swt
    # ColorFactory is used for tracking SWT-backed resources related to colors
    # that potentially need to get disposed. It can additionally take gradients
    # and maybe other values, though, so it can't assume values will be
    # disposable.
    #
    # Additionally this factory does caching against the DSL element so we
    # don't needlessly generate things like OS colors over and over again.
    class ColorFactory
      def initialize
        @swt_elements = {}
      end

      def dispose
        @swt_elements.each_value do |swt_element|
          swt_element.dispose if swt_element.respond_to?(:dispose)
        end
        @swt_elements.clear
      end

      def create(element)
        return nil if element.nil?
        return @swt_elements[element] if @swt_elements.include?(element)

        swt_element = ::Shoes.configuration.backend_for(element)
        @swt_elements[element] = swt_element
        swt_element
      end
    end
  end
end
