# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

Shoes.app do
  if "".blank?
    button "it was blank" do
      alert "meh, that's useless"
    end
  end
end
