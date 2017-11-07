# frozen_string_literal: true

Shoes.app do
  para "Click somewhere"
  click do
    # Earlier versions had trouble because para would get drawn while the
    # alert was up, but before it got positioned. Make sure we don't regress.
    para 'hahahahaha destroy everything'
    alert 'muhhh'
  end
end
