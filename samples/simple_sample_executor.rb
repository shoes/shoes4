Shoes.app width: 650, height: 32 do
  %w(simple_altered_para simple_border_image simple_breadsticks simple_buttons).each do |name|
    button(name) { load "samples/#{name}.rb" }
  end
end
