# frozen_string_literal: true
class Shoes
  class Samples
    def self.path
      File.expand_path(File.join(__FILE__, "..", "..", "..", "samples"))
    end
  end
end
