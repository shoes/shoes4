Shoes.app do
  title 'come on press some keys'
  keypress do |key|
    para 'You pressed ' + key.to_s
    p key
  end
end