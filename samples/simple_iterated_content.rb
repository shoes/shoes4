# frozen_string_literal: true
Shoes.app do
  10.times do |i|
    button "hello#{i}"
    image File.join(Shoes::DIR, 'static/shoes-icon.png')
    edit_line
  end
end
