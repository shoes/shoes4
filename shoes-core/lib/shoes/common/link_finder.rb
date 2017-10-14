# frozen_string_literal: true

class Shoes
  module Common
    module LinkFinder
      def find_links(texts)
        texts.to_a
             .select { |text| text.respond_to?(:links) }
             .map(&:links)
             .flatten
      end
    end
  end
end
