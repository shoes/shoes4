# frozen_string_literal: true
# testing dialog options inside and outside of Shoes.app.
# Quite annoying, I know.

alert 'This alert should pop up before you even see a window!'
if confirm 'Do you really want to see that window?'
  Shoes.app do
    button 'alert' do
      alert 'You pressed a button.'
    end
    button 'confirm' do
      confirm 'You sure?'
    end
  end
else
  alert 'Ok :-( goodbye.'
end
