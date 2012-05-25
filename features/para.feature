Feature: Paragraphs
  In order to make informative applications
  Paragraphs are an important UI element

  Scenario: Paragraphs can be created
    Given a Shoes application
    When I append a paragraph to the main window
    Then I should see a paragraph

  Scenario: Paragraphs should have a text
    Given a Shoes application
    When I append a paragraph with text "Hello world" to the main window
    Then I should see a paragraph with text "Hello world"

