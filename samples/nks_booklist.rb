class BookList < Shoes
  url '/',      :index
  url '/twain', :twain
  url '/kv',    :vonnegut

  def index
    para "Books I've read: ",
      link("by Mark Twain", click: "/twain"),
      link("by Kurt Vonnegut", click: "/kv")
  end

  def twain
    para "Just Huck Finn.\n",
      link("Go back.", click: "/")
  end

  def vonnegut
    para "Cat's Cradle.  Sirens of Titan. ",
      "Breakfast of Champions.\n",
      link("Go back.", click: "/")
  end
end

Shoes.app width: 400, height: 500
