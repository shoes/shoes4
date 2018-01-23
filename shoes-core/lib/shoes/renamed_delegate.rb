# frozen_string_literal: true

class Shoes
  module RenamedDelegate
    include Forwardable

    # Module for delegating method calls while transforming the method names.
    # Used with classes like `Shoes::Dimensions` to delegate X and Y
    # coordinates to the underlying `Shoes::Dimension` classes with more
    # appropriate names.
    #
    # @param [Symbol] getter accessor called to find target for delegation
    # @param [Array<Symbol>] methods target method names to be renamed
    # @param [Hash<String, String>] renamings string keys from the hash are replaced in delegated methods with hash values
    def renamed_delegate_to(getter, methods, renamings)
      methods.each do |method|
        method_name = method.to_s
        renamed_method_name = renamings.inject(method_name) do |name, (word, sub)|
          name.gsub word, sub
        end
        if renamed_method_name != method_name
          def_delegator getter, method_name, renamed_method_name
        end
      end
    end
  end
end
