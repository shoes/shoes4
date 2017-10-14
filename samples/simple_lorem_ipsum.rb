# frozen_string_literal: true

TEXT = <<EOS
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, \
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris \
nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in \
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
    Excepteur sint occaecat cupidatat non proident, sunt in \
culpa qui officia deserunt mollit anim id est laborum.
EOS

NL = "\n\n"

Shoes.app do
  lines = TEXT.split("\n")
  para lines[0], NL
  para lines[1], NL, justify: true
  para lines[2], NL, leading: 0
end
