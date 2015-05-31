# gif taken from here: http://giphy.com/gifs/shoes-3BkLShek8qWJ2
Shoes.app do
  button 'display gif' do
    image File.dirname(__FILE__) + '/shoes.gif'
  end

  button 'download and display gif' do
    image 'http://media.giphy.com/media/3BkLShek8qWJ2/giphy.gif'
  end
end