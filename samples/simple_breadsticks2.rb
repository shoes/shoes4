# frozen_string_literal: true
# Add new method bg and fg to sample17

Shoes.app width: 240, height: 95 do
  para 'Testing, test, test. ',
       strong('Breadsticks. '),
       em('Breadsticks. '),
       code('Breadsticks. '),
       bg(fg(strong(ins('EVEN BETTER.')), white), rgb(255, 0, 192)),
       sub('fine!')
end
