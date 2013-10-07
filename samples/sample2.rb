Shoes.app title: 'Shoes 4 Logo Icon!', width: 310, height: 420 do
  stack do
    path = File.join(Shoes::DIR, 'static/shoes-icon.png')
    image path
    flow do
      image path
      image path
    end
    stack do
      image path
      para ' ' * 20 + 'Powered by JRuby and SWT!'
    end
  end
end
