class PhotoFrame < Shoes
  url '/',        :index
  url '/cy',      :cy
  url '/loogink', :loogink

  def index
    eval(['loogink', 'cy'].sample)
  end

  def loogink
    display tomato, white, "Loogink", "Cy", "She is Loogink"
  end

  def cy
    display paleturquoise, gray, "Cy", "Loogink", "He is Cy"
  end

  def display(bg_color, fg_color, name, other, message)
    background bg_color
    stack do
      inscription 'Shoes 4', left: 80
      image File.expand_path(File.join(__FILE__, "../#{name.downcase}.png")),
        left: 75, top: 25
      para fg(strong(message), fg_color),
        '  ->',
        link(strong(other), click:"/#{other.downcase}"),
        left: 35, top: 85
    end
  end
end

Shoes.app width: 200, height: 120, title: 'Photo Frame'
