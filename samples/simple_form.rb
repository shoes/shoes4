# frozen_string_literal: true

Shoes.app width: 320, height: 420 do
  static_dir = File.expand_path(File.join(__FILE__, ".."))
  background File.join(static_dir, "menu-gray.png")
  image File.join(static_dir, "menu-top.png"), height: 50
  image File.join(static_dir, "menu-left.png"), top: 50, width: 55
  image File.join(static_dir, "menu-right.png"), right: 0, top: 50, width: 55
  image File.join(static_dir, "menu-corner1.png"), top: 0, left: 0
  image File.join(static_dir, "menu-corner2.png"), right: 0, top: 0

  stack margin: 40 do
    stack margin: 10 do
      para "Name"
      @name = list_box items: ["Phyllis", "Ronald", "Wyatt"]
    end
    stack margin: 10 do
      para "Address"
      @address = edit_line
    end
    stack margin: 10 do
      para "Phone"
      @phone = edit_line
    end
    stack margin: 10 do
      button "Save" do
        Shoes.p [@name.text, @address.text, @phone.text]
      end
    end
  end
end
