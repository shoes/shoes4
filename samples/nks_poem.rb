# frozen_string_literal: true

Shoes.app width: 280, height: 350 do
  flow width: 280, margin: 10 do
    stack width: "100%" do
      banner "A POEM"
    end
    stack width: "80px" do
      para "Goes like:"
    end
    stack width: "-90px" do
      para "the sun.\n",
           "a lemon.\n",
           "the goalie.\n",
           "a fireplace.\n",
           "i want to write\n",
           "a poem for the\n",
           "kids who haven't\n",
           "even heard one yet.\n\n",
           "and the goalie guards\n",
           "the fireplace"
    end
  end
end
