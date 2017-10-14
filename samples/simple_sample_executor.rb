# frozen_string_literal: true

Shoes.app width: 650, height: 32 do
  path = File.expand_path(File.join(__FILE__, ".."))
  %w(simple_altered_para simple_border_image simple_breadsticks simple_buttons).each do |name|
    button(name) { load "#{path}/#{name}.rb" }
  end
end
