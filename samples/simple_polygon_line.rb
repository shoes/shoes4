# frozen_string_literal: true

Shoes.app width: 300, height: 300 do
  COLORS = Shoes::COLORS
  i = 45
  button 'new' do
    i += 5
    box = rand(2).zero? ? rect(i, i, 20) : oval(i, i, 20)
    box.style fill: send(COLORS.keys[rand(COLORS.keys.size)])
    @flag = false

    box.click do
      @flag = true
      @box = box
    end

    box.release { @flag = false }
  end
  motion { |left, top| @box.move(left - 10, top - 10) if @flag }
end
