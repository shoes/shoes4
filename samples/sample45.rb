Shoes.app height: 200 do
  font File.join(Shoes::DIR, 'fonts/Coolvetica.ttf')
  stack do
    title 'Good Question'
    title 'Good Question', font: 'Coolvetica'
    title 'Good Question', font: 'Lucida console'
  end
  para 'Arial (default)', left: 400, top: 25
  para 'Coolvetica', left: 400, top: 70
  para 'Lucida Console', left: 400, top: 120
end
