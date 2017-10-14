# frozen_string_literal: true

class Dictionary < Shoes
  url '/',      :index
  url '/(\w+)', :word

  def index
    stack do
      title "Enter a Word"
      @word = edit_line
      button "OK" do
        visit "/#{@word.text}"
      end
    end
  end

  def word(string)
    stack do
      para "No definition found for #{string}. ",
           "Sorry this doesn't actually work."
    end
  end
end

Shoes.app
