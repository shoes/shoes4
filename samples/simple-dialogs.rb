Shoes.app :width => 300, :height => 150, :margin => 10 do
  def answer(v)
    @answer.replace v.inspect
  end

  button "Ask" do
    answer ask("What is your name?")
  end
  button "Confirm" do
    answer confirm("Would you like to proceed?")
  end
  button "Open File..." do
    answer ask_open_file
  end
  button "Save File..." do
    answer ask_save_file
  end
  button "Open Folder..." do
    answer ask_open_folder
  end
  button "Save Folder..." do
    answer ask_save_folder
  end
  button "Color" do
    answer ask_color("Pick a Color")
  end

  @answer = para "Answers appear here"
end
