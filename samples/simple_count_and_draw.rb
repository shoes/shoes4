# frozen_string_literal: true

Shoes.app do
  button 'go' do
    p = para 0, left: 0, top: 30
    a = every do |i|
      i += 1
      j = i * 20
      p.text = i.to_s
      para i.to_s, left: j * 2, top: 30
      oval 100 + j, 100 + j, 10, 10
      a.remove if i > 8
    end

    timer 10 do
      p.text = 'hello'
      para 'shoes 4', left: 0, top: 200
    end
  end
end
