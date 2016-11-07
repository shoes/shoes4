Shoes.app width: 650, height: 32 do
  %w(simple-altered-para simple-border-image simple-breadsticks simple-buttons).each do |name|
    button(name) { load "samples/#{name}.rb" }
  end
end
