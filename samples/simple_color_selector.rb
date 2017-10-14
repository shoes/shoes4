# frozen_string_literal: true

Shoes.app do
  lb = list_box items: Shoes::COLORS.keys.map(&:to_s), choose: 'red' do |s|
    @o.style fill: send(s.text)
    @p.text = s.text
  end.move(300, 0)
  @p = para
  nostroke
  @o = oval 100, 100, 100, 100
  button('print') { para lb.text }.move(500, 0)
end
