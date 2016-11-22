Shoes.app do
  s = stack do
    title 'come on press some keys'
  end

  keypress do |key|
    s.append { para 'You pressed ' + key.to_s }
    p key
  end
  keyrelease do |key|
    s.append { para 'You released ' + key.to_s }
    p key
  end
end
