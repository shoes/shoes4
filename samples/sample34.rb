# Refer to NKS (Nobody Knows Shoes) page 21.

Shoes.app width: 280, height: 350 do
  flow width: 1.0, margin: 10 do
    flow do
      background gold, curve: 10
      stack width: 1.0 do
        banner "A POEM"
      end
      stack width: 80 do
        para "Goes like:"
      end
      stack width: 180 do
        para "the sun.\n",
          "a lemon.\n",
          "the goalie.\n",
          "a fireplace.\n\n",
          "i want to write\n",
          "a poem for the\n",
          "kids who haven't\n",
          "even heard one yet.\n\n",
          "and the goalie guards\n",
          "the fireplace."
      end
    end
  end
end
