# frozen_string_literal: true

Shoes.app width: 700, height: 600 do
  title "Shoes is a ", link("tiny") { alert "Cool!" }, " graphics toolkit. "

  flow width: 0.4 do
    image File.join(Shoes::DIR, 'static/shoes-icon.png'),
          click: ->() { alert "You're soooo quick!" }
  end

  flow width: 0.6 do
    tagline "It's simple and straightforward. ",
            link("Shoes ") { alert "Yay!" },
            "was born to be easy! ",
            link("Shoes ") { alert "Yay!" },
            "was born to be easy! ",
            link("Shoes ") { alert "Yay!" },
            "was born to be easy! ",
            "Really, it was made for absolute beginners. "
  end

  subtitle link(strong(em("There's ", fg(bg("really ", "really ", yellow), "#f00"), "nothing to it. "))) { alert "Have fun!" }
end
