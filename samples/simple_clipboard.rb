# frozen_string_literal: true

Shoes.app do
  stack do
    @line = edit_line "Put text here"
    flow do
      button "Copy" do
        self.clipboard = @line.text
        @buffer.text = "Now click Paste"
      end
      button "Paste" do
        @buffer.text = clipboard
      end
    end

    @buffer = para ""
  end
end
