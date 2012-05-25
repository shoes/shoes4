Feature: Links
  In order to make informative applications
  Links are an important UI element

  Scenario: Links can be created
    Given a Shoes application
    When I append a link to the main window
    Then I should see a link

  Scenario: Links should have a text
    Given a Shoes application
    When I append a link with text "Hello world" to the main window
    Then I should see a link with text "Hello world"

