# frozen_string_literal: true

Shoes.app do
  20.times { |i| button(format("hello%02d", i)) { |s| alert s.text } }
end
