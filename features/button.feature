Feature: Buttons
  In order to make interesting applications
  Buttons are an important UI element

  Scenario: Buttons can be created
    Given a Shoes application
    When I append a button to the main window
    Then I should see a button

  Scenario: Buttons can have a text on them
    Given a Shoes application
    When I append a button with text "Hello world" to the main window
    Then I should see a button with text "Hello world"

  Scenario: Two buttons may be created
    Given a Shoes application
    When I append a button to the main window
    And I append a button to the main window
    Then I should see 2 buttons

