class PhotoFrame
  SPACE = "    "
  include Shoes
  url '/', :index
  url '/loogink', :loogink
  url '/cy', :cy

  def index
    eval(['loogink', 'cy'][rand 2])
  end

  def loogink
    background tomato
    inscription 'Shoes 4'
    flow width: 70 # space
    image File.join(Shoes::DIR, 'samples/loogink.png')
    para SPACE
    para SPACE, fg(strong('She is Loogink.'), white),
      '->', link(strong('Cy')){visit '/cy'}
    p location
  end

  def cy
    background paleturquoise
    inscription 'Shoes 4'
    flow width: 70 # space
    image File.join(Shoes::DIR, 'samples/cy.png')
    para SPACE
    para SPACE, fg(strong('He is Cy.'), gray), '  ->', 
      link(strong('loogink')){visit '/loogink'}
    p location
  end
end

Shoes.app width: 200, height: 120, title: 'Photo Frame'

# TODO: Remove SPACE and use margin style option.
