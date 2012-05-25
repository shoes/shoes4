Feature: Simple.rb
  Simple.rb is a very basic application that just consists of some paragraphs,
  links and buttons.

  Scenario: Buttons can be created
    Given the Shoes application in "features/example_programs/simple.rb"
    Then I should see a button with text "Close"
    And I should see a paragraph
    And I should see a link with text "A sample link"
    And a popup with text "Hello!" should appear

  Scenario: Clicking on Alert results in a popup
    Given the Shoes application in "features/example_programs/simple.rb"
    When I click the button labeled "Alert!"
    Then a popup with text "Hello World!" should appear

  Scenario: You may also check for multiple things
    Given the Shoes application in "features/example_programs/simple.rb"
    Then I should see 2 buttons
    And I should see 1 link

