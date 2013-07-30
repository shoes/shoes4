class Answer < Shoes::Widget
  attr_reader :mark
  def initialize word
    mark = nil
    flow do
      flow(width: 70, height: 20){para word}
      mark = image(File.join(Shoes::DIR, 'samples/loogink.png'), width: 20, height: 20).hide
    end
    @mark = mark
  end
end

Shoes.app width: 200, height: 85 do
  stack width: 0.5 do
    background palegreen
    para '1. apple'
    ans = answer '2. tomato'
    para '3. orange'
    button('Ans.'){ans.mark.toggle}
  end
  stack width: 0.5 do
    background lightsteelblue
    para '1. cat'
    para '2. dog'
    ans = answer '3. bird'
    button('Ans.'){ans.mark.toggle}
  end
end
