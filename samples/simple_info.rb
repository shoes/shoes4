# frozen_string_literal: true

Shoes.app do
  stack do
    # para DIR              # Not support. https://github.com/shoes/shoes4/issues/105
    para Shoes::DIR
    # para Shoes::App::DIR  # Not support. https://github.com/shoes/shoes4/issues/105
    para self.class
    para Shoes.app {}.class
  end
end
