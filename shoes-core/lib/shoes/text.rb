# frozen_string_literal: true

class Shoes
  class Text
    include Common::Inspect
    include Common::LinkFinder

    attr_reader :to_s, :texts, :color
    attr_accessor :parent, :text_block

    def initialize(texts, color = nil)
      @texts      = texts
      @color      = color
      @to_s       = @texts.map(&:to_s).join
      @parent     = nil
      @text_block = nil
    end

    def app
      parent&.app
    end

    def links
      find_links(@texts)
    end

    private

    def inspect_details
      " \"#{self}\""
    end
  end
end
