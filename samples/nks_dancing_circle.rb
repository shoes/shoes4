# frozen_string_literal: true
Shoes.app do
  @o = oval top: 0, left: 0,
            radius: 40

  stack margin: 40 do
    title "Dancing With a Circle"
    subtitle "How graceful and round."
  end

  motion do |x, y|
    @o.move width - x, height - y
  end
end
