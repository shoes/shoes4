Shoes.app do
  s = stack do
    title 'come on press some keys'
  end

  keypress do |key|
    s.append do para 'You pressed ' + key.to_s end
    p key
  end
  keyrelease do |key|
    s.append do para 'You released ' + key.to_s end
    p key
  end
end