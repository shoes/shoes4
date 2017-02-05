# frozen_string_literal: true
Shoes.app title: 'potacho', width: 175, height: 160 do
  background tan

  @imgs = []
  1.upto 59 do |i|
    @imgs << image(File.expand_path(File.join(__FILE__, "../potato_chopping/1258_s#{format('%03d', i)}.gif"))).hide
    @imgs.last.move(10, 10)
  end

  @imgs.first.show

  def potacho
    @imgs[58].hide
    a = animate 12 do |i|
      @imgs[i].show
      @imgs[i - 1].hide if i > 0
      a.remove if i > 57
    end
  end

  button('  start  ') { potacho }.move 10, 130
end
