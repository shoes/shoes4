# frozen_string_literal: true
Shoes.app do
  button('fullscreen') { self.fullscreen = true }
  button('turn back')  { self.fullscreen = false }
end
