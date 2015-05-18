Shoes.app do
  stack margin: 20, width: 250 do
    subtitle "Shoes Notebook"
    para "Add a note."
    @add = edit_line

    button "Save" do
      @notes.append do
          para @add.text, " ",
               link("delete") { |x| x.parent.remove }
      end
      @add.text = ""
    end
  end
  @notes = stack margin: 20, width: -250
end
