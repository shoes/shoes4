# frozen_string_literal: true

# Same snippet as http://shoes-tutorial-note.heroku.com/html/00402_No.1_para.html

Shoes.app width: 240, height: 95 do
  para 'Testing, test, test. ',
       strong('Breadsticks. '),
       em('Breadsticks. '),
       code('Breadsticks. '),
       strong(ins('EVEN BETTER.')),
       sub('fine!')
end
