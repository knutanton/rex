# features/basic_search_feature

Feature: Basic Search
  In order to get smarter
  As a user of student of University og Copenhagen
  I want to search for material regarding 'linux'
  So that I can find awsome material from KB on the topic 'linux'

  Scenario: Single Term Search
    Given I am on the frontpage of REX
    And type 'linux' in the search box
    When I hit the 'search' button
    Then the title of the page should be REX - linux

  Scenario: Limit search to online material (facets)
    Given I am on the frontpage of REX
    And type 'linux' in the search box
    And hit the 'search' button
    When I click the facet 'online material'
    Then all items should have 'online' tabs