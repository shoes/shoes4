# frozen_string_literal: true

class AppComponent < Shoes
  url '/', :index

  def index
    alert("Built-in methods are available in visit methods")
  end
end

Shoes.app width: 800, height: 600, title: 'testing page'
