NOTES = [['Welcome to the vJot Clone', <<-'END']]
This sample app is a notetaker, a clone of PJ Hyett's vjot.com.

Creating
----------
Click "Add a New Note" and the jot will be loaded into the editor for reading or editing.

Editing
---------
Click a jot's title to load it.

Saving
--------
There is no save button, the jot is saved as you edit.

END

Shoes.app :title => "vJot", 
  :width => 420, :height => 560, :resizable => false do

  @note = NOTES.first
  background "#C7EAFB"
  stack :width => 400, :margin => 20 do
    background "#eee", :curve => 12
    border "#00D0FF", :strokewidth => 3, :curve => 12
    stack :margin => 20 do
      caption "vJot"
      @title = edit_line @note[0], :width => 1.0 do
        @note[0] = @title.text
        load_list
      end
      stack :width => 1.0, :height => 200, :scroll => true do
        @list = para
      end
      @jot = edit_box @note[1], :width => 1.0, :height => 200, :margin_bottom => 20 do
        @note[1] = @jot.text
      end
    end
  end

  def load_list
    @list.replace *(NOTES.map { |note|
      [link(note.first) { @note = load_note(note); load_list }, "\n"] 
    }.flatten +
      [link("+ Add a new Note") { NOTES << (@note = load_note); load_list }])
  end

  def load_note(note = ['New Note', ''])
    @note = note
    @title.text = note[0]
    @jot.text = note[1]
    note
  end

  load_list
end
