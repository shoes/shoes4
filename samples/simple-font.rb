Shoes.app height: 200 do
  font File.join(Shoes::DIR, 'fonts/Coolvetica.ttf')
  stack do
    flow do
      title 'Good Question'
      para 'Arial (default)', left: 400, top: 20
    end
    flow do
      title 'Cool Question', font: 'Coolvetica'
      para 'Coolvetica', left: 400, top: 20
    end
    flow do
      title 'Lucid Question', font: 'Lucida console'
      para 'Lucida Console', left: 400, top: 20
    end
  end
end
