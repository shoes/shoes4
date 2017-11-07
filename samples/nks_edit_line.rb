# frozen_string_literal: true

Shoes.app do
  @e = edit_line width: 400
  button "O.K." do
    alert @e.text
  end
end
