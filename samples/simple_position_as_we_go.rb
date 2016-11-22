Shoes.app do
  stack do
    @p = para "Things get placed"
    @b = button "as we go"

    para "#{@p.element_left}, #{@p.element_top} -> #{@p.width}, #{@p.height}"
    para "#{@b.element_left}, #{@b.element_top} -> #{@b.width}, #{@b.height}"
  end
end
